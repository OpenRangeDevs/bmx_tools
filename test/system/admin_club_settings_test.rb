require "application_system_test_case"

class AdminClubSettingsTest < ApplicationSystemTestCase
  def setup
    @club = clubs(:airdrie_bmx)
    @club_admin = users(:club_admin)
    @super_admin = users(:super_admin)
    @regular_user = users(:regular_user)

    # Set up club ownership
    @club.update!(owner_user: @club_admin)
  end

  test "club owner can access settings page and see all tabs" do
    login_as(@club_admin)

    visit admin_club_settings_path(@club)

    assert_text "Club Settings"
    assert_selector "button", text: "General Settings"
    assert_selector "button", text: "Members"
    assert_selector "button", text: "Ownership"
    assert_selector "button", text: "Danger Zone"
  end

  test "club owner can update general settings" do
    login_as(@club_admin)

    visit admin_club_settings_path(@club)

    # Should start on General tab
    assert_selector ".border-indigo-500", text: "General Settings"

    fill_in "Name", with: "Updated Airdrie BMX Club"
    fill_in "Location", with: "Airdrie, Alberta (Updated)"
    fill_in "Website URL", with: "https://updated.airdriebmx.ca"
    fill_in "Description", with: "An updated description for our amazing BMX club"

    click_button "Update General Settings"

    assert_text "Club settings updated successfully"

    @club.reload
    assert_equal "Updated Airdrie BMX Club", @club.name
    assert_equal "https://updated.airdriebmx.ca", @club.website_url
  end

  test "club owner can navigate between tabs" do
    login_as(@club_admin)

    visit admin_club_settings_path(@club)

    # Start on General tab
    assert_selector ".border-indigo-500", text: "General Settings"
    assert_text "Club Name"

    # Click Members tab
    click_button "Members"
    assert_selector ".border-indigo-500", text: "Members"
    assert_text "Add New Member"

    # Click Ownership tab
    click_button "Ownership"
    assert_selector ".border-indigo-500", text: "Ownership"
    assert_text "Transfer Ownership"

    # Click Danger Zone tab
    click_button "Danger Zone"
    assert_selector ".border-indigo-500", text: "Danger Zone"
    assert_text "Delete Club"
  end

  test "club owner can add new member" do
    login_as(@club_admin)

    visit admin_club_settings_path(@club)

    # Wait for page to load and JavaScript tabs to initialize
    assert_text "Club Settings"
    sleep(0.5)

    click_button "Members"

    within ".bg-gray-50" do
      fill_in "email", with: @regular_user.email
      select "Club Admin", from: "role"
      click_button "Add Member"
    end

    assert_text "User #{@regular_user.email} added as Club admin"

    # Verify member appears in the list
    within ".bg-gray-50" do
      assert_text @regular_user.email
      assert_text "Club Admin"
    end
  end

  test "club owner can initiate ownership transfer" do
    login_as(@club_admin)

    visit admin_club_settings_path(@club)
    click_button "Ownership"

    fill_in "to_user_email", with: @regular_user.email
    click_button "Transfer Ownership"

    assert_text "Ownership transfer initiated"
    assert_text @regular_user.email

    # Should show pending transfer details
    assert_text "Pending Transfer"
    assert_button "Cancel Transfer"
  end

  test "club owner sees confirmation dialog for soft delete" do
    login_as(@club_admin)

    visit admin_club_settings_path(@club)
    click_button "Danger Zone"

    # Click soft delete and check for confirmation
    accept_confirm do
      click_button "Delete Club"
    end

    assert_current_path admin_clubs_path
    assert_text "Club '#{@club.name}' has been deleted"
  end

  test "super admin can access any club settings" do
    login_as(@super_admin)

    visit admin_clubs_path

    # Find Airdrie BMX club row and click Settings
    within "tr", text: @club.name do
      click_on "Settings"
    end

    assert_text "Settings for #{@club.name}"
    assert_selector "button", text: "General"
  end

  test "super admin sees additional options in danger zone" do
    login_as(@super_admin)

    visit admin_club_settings_path(@club)
    click_button "Danger Zone"

    # Super admin should see both soft delete and hard delete options
    assert_button "Delete Club"
    assert_button "Permanently Delete Club"
    assert_text "Hard Delete"
  end

  test "unauthorized user cannot access settings" do
    login_as(@regular_user)

    visit admin_club_settings_path(@club)

    assert_current_path login_path
    assert_text "Access denied"
  end

  test "settings page shows current members list" do
    login_as(@club_admin)

    # Add a member first
    @regular_user.tool_permissions.create!(
      tool: "race_management",
      role: "club_operator",
      club: @club
    )

    visit admin_club_settings_path(@club)
    click_button "Members"

    # Should show existing members
    within ".bg-gray-50" do
      assert_text @regular_user.email
      assert_text "Club Operator"
      assert_button "Remove"
    end
  end

  test "club owner can remove member" do
    login_as(@club_admin)

    # Add a member first
    @regular_user.tool_permissions.create!(
      tool: "race_management",
      role: "club_operator",
      club: @club
    )

    visit admin_club_settings_path(@club)
    click_button "Members"

    # Remove the member
    within ".bg-gray-50", text: @regular_user.email do
      accept_confirm do
        click_button "Remove"
      end
    end

    assert_text "User #{@regular_user.email} removed from club"

    # Member should no longer appear in the list
    assert_no_text @regular_user.email
  end

  test "form validation errors are displayed properly" do
    login_as(@club_admin)

    visit admin_club_settings_path(@club)

    # Try to submit empty name
    fill_in "Name", with: ""
    click_button "Update General Settings"

    # Should show validation error and stay on same page
    assert_selector ".text-red-600", text: "can't be blank"
    assert_current_path admin_club_settings_path(@club)
  end

  test "pending ownership transfer is displayed correctly" do
    # Create a pending transfer
    transfer = @club.ownership_transfers.create!(
      from_user: @club_admin,
      to_user_email: @regular_user.email
    )

    login_as(@club_admin)

    visit admin_club_settings_path(@club)
    click_button "Ownership"

    assert_text "Pending Transfer"
    assert_text @regular_user.email
    assert_text "3 days"  # Days until expiry
    assert_button "Cancel Transfer"
  end

  test "club owner can cancel pending ownership transfer" do
    # Create a pending transfer
    transfer = @club.ownership_transfers.create!(
      from_user: @club_admin,
      to_user_email: @regular_user.email
    )

    login_as(@club_admin)

    visit admin_club_settings_path(@club)
    click_button "Ownership"

    # Wait for the page to load
    assert_text "Ownership Transfer Pending"

    # The form should handle the confirmation
    click_button "Cancel Transfer"

    assert_text "Ownership transfer cancelled"
    assert_no_text "Pending Transfer"
  end

  private

  def login_as(user)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "roger123!"
    click_button "Sign in"
  end
end
