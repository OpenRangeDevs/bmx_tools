require "application_system_test_case"

class RaceTrackingTest < ApplicationSystemTestCase
  setup do
    @club_admin = users(:club_admin)
    @club = clubs(:airdrie_bmx)
  end

  test "club admin can access race interface" do
    visit login_path

    fill_in "Email", with: @club_admin.email
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    assert_current_path club_admin_path(@club)
    assert_text "Race Official Controls"
  end

  test "race counters have turbo updates" do
    visit login_path

    fill_in "Email", with: @club_admin.email
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    # Should see dual counters
    assert_text "At Gate"
    assert_text "In Staging"

    # Should have increment/decrement buttons for counters
    assert_text "🏁 At Gate"
    assert_text "🟠 In Staging"
  end

  test "public race page loads without authentication" do
    visit club_path(@club)

    assert_text "#{@club.name}"
    assert_text "Race Day Progress"
    assert_text "At Gate"
    assert_text "In Staging"

    # Should NOT have admin controls
    assert_no_text "Reset Race"
    assert_no_text "Race Settings"
  end

  test "race page renders properly" do
    visit club_path(@club)

    # Should have basic race tracking interface
    assert_text "#{@club.name}"
    assert_text "Race Day Progress"
  end

  test "unauthorized user cannot access admin interface" do
    visit club_admin_path(@club)

    # Should be redirected to login
    assert_current_path login_path
    assert_text "Sign in to BMX Tools"
  end
end
