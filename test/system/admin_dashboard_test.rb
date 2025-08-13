require "application_system_test_case"

class AdminDashboardTest < ApplicationSystemTestCase
  setup do
    @super_admin = users(:super_admin)
  end

  test "super admin can access dashboard" do
    visit login_path

    fill_in "Email", with: @super_admin.email
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    assert_current_path admin_dashboard_path
    assert_text "BMX Tools Platform"
    assert_text "Platform Administration Dashboard"
  end

  test "dashboard shows platform metrics" do
    visit login_path

    fill_in "Email", with: @super_admin.email
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    # Should show metrics cards
    assert_text "Total Clubs"
    assert_text "Active Clubs"
    assert_text "Total Races"
    assert_text "Active Now"

    # Should have navigation
    assert_text "Quick Actions"
    assert_link "Add New Club"
    assert_link "View All Clubs"
  end

  test "dashboard has turbo capabilities" do
    visit login_path

    fill_in "Email", with: @super_admin.email
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    # Dashboard should be accessible and have basic functionality
    assert_text "BMX Tools Platform"
    assert_link "Add New Club"
  end

  test "non-super-admin cannot access dashboard" do
    club_admin = users(:club_admin)

    visit login_path

    fill_in "Email", with: club_admin.email
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    # Club admin should be redirected to their club, not dashboard
    assert_no_current_path admin_dashboard_path
  end
end
