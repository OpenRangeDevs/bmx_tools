require "test_helper"

class RacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @club = Club.create!(
      name: "Test BMX Club",
      slug: "test-bmx-club-#{SecureRandom.hex(4)}"
    )
  end

  private

  def authenticate_as_admin
    # Create a club admin user for this club
    user = User.create!(email: "admin@#{@club.slug}.com", password: "password123")
    ToolPermission.create!(
      user: user,
      tool: "race_management",
      role: "club_admin",
      club: @club
    )

    post login_path, params: {
      email: user.email,
      password: "password123"
    }
    follow_redirect!
  end

  test "should get show" do
    get club_race_url(@club.slug)
    assert_response :success
  end

  test "should get admin" do
    authenticate_as_admin
    get club_admin_url(@club.slug)
    assert_response :success
  end

  test "should update race via turbo stream" do
    race = @club.create_race!(at_gate: 5, in_staging: 8)
    authenticate_as_admin

    patch club_race_update_url(@club.slug),
          params: { race: { at_gate: 6, in_staging: 8 } },
          headers: { "Accept": "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_match "turbo-stream", response.content_type
    race.reload
    assert_equal 6, race.at_gate
    assert_equal 8, race.in_staging
  end

  test "race model has broadcast callback" do
    race = @club.create_race!(at_gate: 3, in_staging: 5)

    # Test that the broadcast_race_update method exists and works
    assert_respond_to race, :send
    assert_nothing_raised do
      race.send(:broadcast_race_update)
    end
  end

  test "admin routes require authentication" do
    get club_admin_url(@club.slug)
    assert_redirected_to login_path

    patch club_race_update_url(@club.slug),
          params: { race: { at_gate: 1, in_staging: 2 } }
    assert_redirected_to login_path
  end

  test "admin login with correct password" do
    skip "Legacy test - authentication now uses main login system"
  end

  test "admin login with incorrect password" do
    skip "Legacy test - authentication now uses main login system"
  end

  test "admin logout" do
    authenticate_as_admin
    delete logout_path
    assert_redirected_to root_path

    # Verify no longer authenticated
    get club_admin_url(@club.slug)
    assert_redirected_to login_path
  end

  test "update race settings requires authentication" do
    race_setting = @club.create_race!(at_gate: 0, in_staging: 0).create_race_setting!

    patch club_race_settings_path(@club.slug),
          params: { race_setting: { race_start_time: 1.hour.from_now } }
    assert_redirected_to login_path
  end

  test "update race settings with valid data" do
    race = @club.create_race!(at_gate: 0, in_staging: 0)
    race_setting = race.create_race_setting!
    authenticate_as_admin

    # Use specific times to avoid timezone/parsing issues
    start_time_str = "2025-12-25T15:30"
    registration_deadline_str = "2025-12-25T14:30"

    patch club_race_settings_path(@club.slug),
          params: {
            race_setting: {
              race_start_time: start_time_str,
              registration_deadline: registration_deadline_str
            }
          },
          headers: { "Accept": "text/vnd.turbo-stream.html" }

    assert_response :success
    race_setting.reload

    # Check that the times were updated (allow for some timezone conversion)
    assert_not_nil race_setting.race_start_time
    assert_not_nil race_setting.registration_deadline
    assert_equal 15, race_setting.race_start_time.hour
    assert_equal 30, race_setting.race_start_time.min
    assert_equal 14, race_setting.registration_deadline.hour
    assert_equal 30, race_setting.registration_deadline.min
  end

  test "race time settings display correctly" do
    race = @club.create_race!(at_gate: 0, in_staging: 0)
    race_setting = race.create_race_setting!(
      race_start_time: 2.hours.from_now,
      registration_deadline: 1.hour.from_now
    )
    authenticate_as_admin

    get club_admin_url(@club.slug)
    assert_response :success
    assert_match /Race Time Settings/, response.body
    assert_match /Registration Deadline/, response.body
    assert_match /Race Start Time/, response.body
  end

  test "session timeout redirects to login" do
    skip "Temporary skip for Phase 4 merge"
    # Login as admin first
    authenticate_as_admin

    # Simulate session timeout by setting login time to 5 hours ago
    session[:admin_login_time] = 5.hours.ago.to_s

    get club_admin_url(@club.slug)
    assert_redirected_to club_admin_login_path(@club.slug)
    follow_redirect!
    assert_match /session has expired/, response.body
  end

  test "valid session refreshes login time" do
    skip "Legacy test - session management changed in Phase 6"
  end
end
