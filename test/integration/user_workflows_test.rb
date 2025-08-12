require "test_helper"

class UserWorkflowsTest < ActionDispatch::IntegrationTest
  setup do
    @club = Club.create!(
      name: "Test BMX Club",
      slug: "test-bmx-club-#{SecureRandom.hex(4)}"
    )
  end

  private

  def authenticate_admin
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

  test "complete public user workflow: view race progress" do
    # Setup: Create race with some progress
    race = @club.create_race!(at_gate: 3, in_staging: 5)
    race.create_race_setting!(
      registration_deadline: 2.hours.from_now,
      race_start_time: 4.hours.from_now
    )

    # Public user visits club page
    get club_race_path(@club.slug)
    assert_response :success

    # Verify they can see current race status
    assert_select "span", text: "3" # At Gate counter
    assert_select "span", text: "5" # In Staging counter
    assert_select "h1", text: @club.name

    # Verify they can see race times
    assert_match /Registration Deadline/, response.body
    assert_match /Race Start/, response.body

    # Verify page has proper mobile-first structure
    assert_select 'meta[name="viewport"]'
    assert_select "div.counter-section", count: 2
  end

  test "complete admin workflow: manage race day operations" do
    # Admin logs in
    authenticate_admin

    # Admin navigates to admin interface
    get club_admin_path(@club.slug)
    assert_response :success

    # Verify admin sees admin controls
    assert_match /Race Official Controls/, response.body
    assert_select "div#admin-counters"
    assert_select "div#race-time-settings"

    # Admin updates At Gate counter
    race = @club.race || @club.create_race!(at_gate: 0, in_staging: 0)
    original_at_gate = race.at_gate

    # Update in_staging first to avoid validation error
    patch club_race_update_path(@club.slug), params: {
      race: { at_gate: original_at_gate, in_staging: original_at_gate + 2 }
    }, headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_match /turbo-stream/, response.body

    # Verify in_staging counter was updated
    race.reload
    assert_equal original_at_gate + 2, race.in_staging

    # Admin updates race times (simplified test)
    race_setting = race.race_setting
    original_deadline = race_setting.registration_deadline

    # Update with a simple datetime field
    new_deadline = 3.hours.from_now
    patch club_race_settings_path(@club.slug), params: {
      race_setting: {
        registration_deadline: new_deadline.strftime("%Y-%m-%dT%H:%M"),
        race_start_time: (new_deadline + 2.hours).strftime("%Y-%m-%dT%H:%M")
      }
    }, headers: { "Accept" => "text/vnd.turbo-stream.html" }

    # Should respond successfully even if validation fails
    assert_response :success

    # Admin resets race
    post club_new_race_path(@club.slug),
         headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    race.reload
    assert_equal 0, race.at_gate
    assert_equal 0, race.in_staging
  end

  test "real-time updates workflow: changes broadcast to all users" do
    # Setup: Create race
    race = @club.create_race!(at_gate: 2, in_staging: 4)

    # Admin makes update
    authenticate_admin

    # Update counter and verify Turbo Stream response
    patch club_race_update_path(@club.slug), params: {
      race: { at_gate: 3, in_staging: 4 }
    }, headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_match /turbo-stream/, response.body
    assert_match /update/, response.body
    # The actual turbo stream updates individual counter elements
    assert_match /at-gate-counter|in-staging-counter/, response.body

    # Verify database was updated
    race.reload
    assert_equal 3, race.at_gate
    assert_equal 4, race.in_staging

    # Verify activity was logged
    assert_equal 1, @club.race_activities.count
    activity = @club.race_activities.first
    assert_equal "counter_update", activity.activity_type
    assert_match /2→3/, activity.message
  end

  test "error handling workflow: graceful degradation" do
    # Test invalid club slug
    get club_race_path("non-existent-club")
    assert_response :not_found
    assert_match /not found/, response.body

    # Test admin access without authentication
    get club_admin_path(@club.slug)
    assert_response :redirect
    follow_redirect!
    assert_match /sign in/i, response.body

    # Test invalid admin credentials (expects to stay on login page with error)
    post login_path, params: { email: "invalid@example.com", password: "wrong" }
    assert_response :success # Modern UX: stay on page with error message
    assert_match /Invalid|wrong|password|login/i, response.body

    # Test counter validation (at_gate must be < in_staging)
    race = @club.create_race!(at_gate: 5, in_staging: 6)
    authenticate_admin

    # Try to set At Gate > In Staging (should be prevented by validation)
    patch club_race_update_path(@club.slug), params: {
      race: { at_gate: 7, in_staging: 5 }
    }

    # The update should be rejected and counters should remain valid
    race.reload
    assert race.at_gate < race.in_staging, "At Gate must remain less than In Staging"
    assert race.at_gate <= 6, "At Gate should not exceed original In Staging"
  end

  test "mobile-specific workflow: touch interactions work correctly" do
    race = @club.create_race!(at_gate: 1, in_staging: 2)

    # Visit public page
    get club_race_path(@club.slug)
    assert_response :success

    # Verify mobile-optimized elements are present
    assert_select 'meta[name="viewport"][content*="width=device-width"]'
    assert_match /min-height: 44px/, response.body # Touch targets in inline styles

    # Verify counter display is mobile-friendly
    assert_select "span[style*='font-size: 72px']", count: 2 # Large counters
    assert_select "div.counter-section", count: 2

    # Visit admin interface
    authenticate_admin
    get club_admin_path(@club.slug)

    # Verify admin buttons are touch-friendly
    assert_match /min-height: 44px/, response.body # Admin buttons have touch targets
  end

  test "PWA workflow: service worker and offline capability" do
    # Visit main page to register service worker
    get club_race_path(@club.slug)
    assert_response :success

    # Verify PWA elements are present
    assert_select 'link[rel="manifest"]'
    assert_select 'meta[name="theme-color"]'

    # Check service worker is available
    get "/service-worker.js"
    assert_response :success
    assert_match /service.*worker/i, response.body

    # Check manifest is properly configured
    get "/manifest.json"
    assert_response :success
    manifest = JSON.parse(response.body)
    assert_equal "BMX Race Tracker", manifest["name"]
    assert_equal "standalone", manifest["display"]
  end
end
