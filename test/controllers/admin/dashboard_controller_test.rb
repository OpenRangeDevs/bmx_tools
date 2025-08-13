require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @super_admin = users(:super_admin)
    @club_admin = users(:club_admin)
  end

  def login_as_super_admin
    post login_path, params: {
      email: @super_admin.email,
      password: "roger123!"
    }
  end

  def login_as_club_admin
    post login_path, params: {
      email: @club_admin.email,
      password: "password123"
    }
  end

  test "should require super admin authentication" do
    get admin_dashboard_path
    assert_redirected_to login_path
  end

  test "should deny access to club admin" do
    login_as_club_admin
    get admin_dashboard_path
    assert_redirected_to root_path
    assert_equal "Access denied", flash[:alert]
  end

  test "should display dashboard for super admin" do
    login_as_super_admin
    get admin_dashboard_path
    assert_response :success
    assert_select "h1", "BMX Tools Platform"
  end

  test "should display platform metrics" do
    # Create some test data
    club1 = Club.create!(name: "Test Club 1", slug: "test-club-1")
    club2 = Club.create!(name: "Test Club 2", slug: "test-club-2")
    race1 = club1.create_race!(at_gate: 1, in_staging: 2)
    race2 = club2.create_race!(at_gate: 0, in_staging: 1)

    login_as_super_admin
    get admin_dashboard_path

    assert_response :success

    # Check that metrics are displayed
    assert_select ".text-2xl.font-bold.text-gray-900", text: /\d+/ # Total clubs count
    assert_match "Total Clubs", response.body
    assert_match "Active Clubs", response.body
    assert_match "Total Races", response.body
    assert_match "Active Now", response.body
  end

  test "should display quick action buttons" do
    login_as_super_admin
    get admin_dashboard_path

    assert_response :success
    assert_select "a", text: "Add New Club"
    assert_select "a", text: "View All Clubs"
    assert_select "a", text: "Platform Settings"
  end

  test "should display admin navigation" do
    login_as_super_admin
    get admin_dashboard_path

    assert_response :success
    assert_select "nav a", text: "Dashboard"
    assert_select "nav a", text: "Clubs"
    assert_select "nav a", text: "Settings"
  end

  test "should display user info and logout link" do
    login_as_super_admin
    get admin_dashboard_path

    assert_response :success
    assert_match @super_admin.email, response.body
    assert_select "a", text: "Logout"
  end

  test "should handle empty data gracefully" do
    # Clear all races first (due to foreign key constraints)
    Race.destroy_all
    # Clear race settings
    RaceSetting.destroy_all
    # Clear clubs
    Club.where.not(id: clubs(:calgary_bmx).id).destroy_all # Keep fixture club for other tests

    login_as_super_admin
    get admin_dashboard_path

    assert_response :success
    # Should show at least 1 club (the fixture club)
    assert_select ".text-2xl.font-bold.text-gray-900", text: /\d+/
  end

  test "should display recent activity when available" do
    # Create a recent club
    club = Club.create!(name: "Recent Club", slug: "recent-club")

    login_as_super_admin
    get admin_dashboard_path

    assert_response :success
    assert_match "Recent Activity", response.body
    assert_match "New club created: Recent Club", response.body
  end

  test "should handle no recent activity" do
    # Ensure no recent activity
    Club.update_all(created_at: 2.days.ago)
    Race.update_all(updated_at: 1.day.ago)

    login_as_super_admin
    get admin_dashboard_path

    assert_response :success
    assert_match "No recent activity", response.body
  end
end
