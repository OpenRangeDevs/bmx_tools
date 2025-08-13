require "test_helper"

class Admin::ClubsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @super_admin = users(:super_admin)
    @club_admin = users(:club_admin)
    @club = clubs(:airdrie_bmx)
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
      password: "roger123!"
    }
  end

  test "should get index" do
    login_as_super_admin
    get admin_clubs_url
    assert_response :success
    assert_select "h1", "Clubs Management"
  end

  test "should get show" do
    login_as_super_admin
    get admin_club_url(@club)
    assert_response :success
    assert_select "h1", @club.name
  end

  test "should get new" do
    login_as_super_admin
    get new_admin_club_url
    assert_response :success
    assert_select "h1", "Add New Club"
  end

  test "should create club" do
    login_as_super_admin
    assert_difference("Club.count") do
      post admin_clubs_url, params: {
        club: {
          name: "Test BMX Club",
          location: "Test City, AB",
          timezone: "Mountain Time (US & Canada)"
        }
      }
    end

    club = Club.find_by(name: "Test BMX Club")
    assert_redirected_to admin_club_url(club)
    assert_equal "Club was successfully created.", flash[:notice]
  end

  test "should create club with admin user" do
    login_as_super_admin
    assert_difference([ "Club.count", "User.count", "ToolPermission.count" ]) do
      post admin_clubs_url, params: {
        club: {
          name: "Test BMX Club",
          location: "Test City, AB",
          timezone: "Mountain Time (US & Canada)"
        },
        admin_email: "admin@testclub.com"
      }
    end

    club = Club.find_by(name: "Test BMX Club")
    user = User.find_by(email: "admin@testclub.com")

    assert_not_nil user
    assert_not_nil club.tool_permissions.find_by(user: user)
    assert flash[:admin_credentials].present?
  end

  test "should get edit" do
    login_as_super_admin
    get edit_admin_club_url(@club)
    assert_response :success
    assert_select "h1", "Edit #{@club.name}"
  end

  test "should update club" do
    login_as_super_admin
    patch admin_club_url(@club), params: {
      club: {
        name: "Updated Club Name",
        location: "Updated Location"
      }
    }
    assert_redirected_to admin_club_url(@club)

    @club.reload
    assert_equal "Updated Club Name", @club.name
    assert_equal "Updated Location", @club.location
  end

  test "should soft delete club" do
    login_as_super_admin
    assert_no_difference("Club.unscoped.count") do
      delete admin_club_url(@club)
    end

    @club.reload
    assert @club.deleted?
    assert_redirected_to admin_clubs_url
    assert_equal "Club was successfully deleted.", flash[:notice]
  end

  test "should search clubs" do
    login_as_super_admin
    get admin_clubs_url, params: { search: "Airdrie" }
    assert_response :success
    assert_select "td", text: /Airdrie/
  end

  test "should filter clubs by status" do
    login_as_super_admin
    # Create a deleted club
    deleted_club = Club.create!(name: "Deleted Club", slug: "deleted-club", location: "Test", timezone: "Mountain Time (US & Canada)")
    deleted_club.update!(deleted_at: Time.current)

    get admin_clubs_url, params: { status: "active" }
    assert_response :success

    get admin_clubs_url, params: { status: "deleted" }
    assert_response :success
  end

  test "should require super admin authentication" do
    get admin_clubs_url
    assert_redirected_to login_path

    # Test with regular user
    login_as_club_admin
    get admin_clubs_url
    assert_redirected_to root_path
    assert_equal "Access denied", flash[:alert]
  end

  test "should not allow slug change when club has races" do
    login_as_super_admin
    # Ensure club has a race
    @club.race || Race.create!(club: @club, at_gate: 0, in_staging: 0)

    patch admin_club_url(@club), params: {
      club: { slug: "new-slug" }
    }

    @club.reload
    assert_not_equal "new-slug", @club.slug
  end

  test "should handle validation errors on create" do
    login_as_super_admin
    post admin_clubs_url, params: {
      club: {
        name: "", # Invalid - name is required
        location: "Test City",
        timezone: "America/Edmonton"
      }
    }

    assert_response :unprocessable_entity
    assert_select "div.bg-red-50" # Error messages
  end

  test "should handle validation errors on update" do
    login_as_super_admin
    patch admin_club_url(@club), params: {
      club: { name: "" } # Invalid - name is required
    }

    assert_response :unprocessable_entity
    assert_select "div.bg-red-50" # Error messages
  end
end
