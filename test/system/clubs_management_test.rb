require "application_system_test_case"

class ClubsManagementTest < ApplicationSystemTestCase
  setup do
    @super_admin = users(:super_admin)
  end

  test "super admin can view clubs list" do
    visit login_path

    fill_in "Email", with: @super_admin.email
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    click_link "View All Clubs"

    assert_current_path admin_clubs_path
    assert_text "Clubs Management"
  end

  test "can create new club through UI" do
    visit login_path

    fill_in "Email", with: @super_admin.email
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    click_link "Add New Club"

    assert_current_path new_admin_club_path
    assert_text "Add New Club"

    fill_in "Club Name", with: TEST_CLUB_NAME
    fill_in "Location", with: TEST_CLUB_LOCATION
    fill_in "Admin Email", with: TEST_ADMIN_EMAIL

    click_button "Create Club"

    # Should redirect to club show page after creation
    assert_text SUCCESS_REDIRECT_MESSAGE
    assert_text TEST_CLUB_NAME
  end

  test "club form has proper turbo behavior" do
    visit login_path

    fill_in "Email", with: @super_admin.email
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    click_link "Add New Club"

    # Form should be present and ready for submission (Turbo is enabled by default)
    assert_selector 'form[action="/admin/clubs"]'
    assert_button "Create Club"
  end

  test "club list has search functionality" do
    visit login_path

    fill_in "Email", with: @super_admin.email
    fill_in "Password", with: TEST_PASSWORD
    click_button "Sign in"

    click_link "View All Clubs"

    assert_text "Search clubs"
    assert_selector 'input[name="search"]'
    assert_text "All Clubs"  # Status filter option
  end
end
