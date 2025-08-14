require "test_helper"

class Admin::Clubs::SettingsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @club = clubs(:airdrie_bmx)
    @super_admin = users(:super_admin)
    @club_admin = users(:club_admin)
    @club_operator = users(:club_operator)
    @regular_user = users(:regular_user)

    # Set up club ownership
    @club.update!(owner_user: @club_admin)
  end

  test "should get settings page as super admin" do
    login_as_super_admin
    get admin_club_settings_path(@club)
    assert_response :success
    assert_select "h1", text: "Club Settings"
  end

  test "should get settings page as club owner" do
    login_as_club_admin
    get admin_club_settings_path(@club)
    assert_response :success
    assert_select "h1", text: "Club Settings"
  end

  test "should redirect unauthorized user from settings" do
    login_as_regular_user
    get admin_club_settings_path(@club)
    assert_redirected_to admin_dashboard_path
    assert_equal "You don't have permission to manage this club.", flash[:alert]
  end

  test "should update general settings as owner" do
    login_as_club_admin
    patch update_general_admin_club_settings_path(@club), params: {
      club: {
        name: "Updated Airdrie BMX",
        location: "Airdrie, AB - Updated",
        website_url: "https://updated.airdriebmx.ca",
        description: "Updated description for the club"
      }
    }

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "Club settings updated successfully.", flash[:notice]

    @club.reload
    assert_equal "Updated Airdrie BMX", @club.name
    assert_equal "Airdrie, AB - Updated", @club.location
    assert_equal "https://updated.airdriebmx.ca", @club.website_url
    assert_equal "Updated description for the club", @club.description
  end

  test "should handle validation errors in general settings update" do
    login_as_club_admin
    patch update_general_admin_club_settings_path(@club), params: {
      club: { name: "" }
    }

    assert_response :unprocessable_entity
    assert_select ".text-red-600", text: /can't be blank/
  end

  test "should add member with club_admin role" do
    login_as_club_admin
    new_user_email = @regular_user.email

    assert_difference "@club.users.count", 1 do
      post add_member_admin_club_settings_path(@club), params: {
        email: new_user_email,
        role: "club_admin"
      }
    end

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "User #{new_user_email} added as Club admin.", flash[:notice]

    permission = @regular_user.tool_permissions.find_by(club: @club)
    assert_equal "club_admin", permission.role
  end

  test "should add member with club_operator role" do
    login_as_club_admin
    new_user_email = @regular_user.email

    post add_member_admin_club_settings_path(@club), params: {
      email: new_user_email,
      role: "club_operator"
    }

    assert_redirected_to admin_club_settings_path(@club)
    permission = @regular_user.tool_permissions.find_by(club: @club)
    assert_equal "club_operator", permission.role
  end

  test "should reject invalid role when adding member" do
    login_as_club_admin
    post add_member_admin_club_settings_path(@club), params: {
      email: @regular_user.email,
      role: "invalid_role"
    }

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "Invalid role selected.", flash[:alert]
  end

  test "should handle non-existent user when adding member" do
    login_as_club_admin
    post add_member_admin_club_settings_path(@club), params: {
      email: "nonexistent@example.com",
      role: "club_admin"
    }

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "User with email nonexistent@example.com not found.", flash[:alert]
  end

  test "should prevent adding existing member" do
    login_as_club_admin
    existing_user = @club_operator  # Already has access to this club

    post add_member_admin_club_settings_path(@club), params: {
      email: existing_user.email,
      role: "club_admin"
    }

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "User already has access to this club.", flash[:alert]
  end

  test "should update member role" do
    login_as_club_admin
    member_permission = @club_operator.tool_permissions.find_by(club: @club)
    original_role = member_permission.role

    patch update_member_admin_club_settings_path(@club), params: {
      user_id: @club_operator.id,
      role: "club_admin"
    }

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "User role updated to Club admin.", flash[:notice]

    member_permission.reload
    assert_equal "club_admin", member_permission.role
    assert_not_equal original_role, member_permission.role
  end

  test "should reject invalid role when updating member" do
    login_as_club_admin
    patch update_member_admin_club_settings_path(@club), params: {
      user_id: @club_operator.id,
      role: "invalid_role"
    }

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "Invalid role selected.", flash[:alert]
  end

  test "should remove member from club" do
    login_as_club_admin

    assert_difference "@club.users.count", -1 do
      delete remove_member_admin_club_settings_path(@club), params: {
        user_id: @club_operator.id
      }
    end

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "User #{@club_operator.email} removed from club.", flash[:notice]

    permission = @club_operator.tool_permissions.find_by(club: @club)
    assert_nil permission
  end

  test "should prevent removing club owner" do
    login_as_club_admin
    delete remove_member_admin_club_settings_path(@club), params: {
      user_id: @club_admin.id  # The owner
    }

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "Cannot remove club owner. Transfer ownership first.", flash[:alert]
  end

  test "should initiate ownership transfer as owner" do
    login_as_club_admin
    target_email = @regular_user.email

    assert_difference "OwnershipTransfer.count", 1 do
      post initiate_transfer_admin_club_settings_path(@club), params: {
        to_user_email: target_email
      }
    end

    assert_redirected_to admin_club_settings_path(@club)
    assert_match(/Ownership transfer initiated/, flash[:notice])

    transfer = @club.ownership_transfers.active.first
    assert_equal target_email, transfer.to_user_email
    assert_equal @club_admin, transfer.from_user
  end

  test "should prevent non-owner from initiating transfer" do
    login_as(@club_operator)  # Not the owner
    post initiate_transfer_admin_club_settings_path(@club), params: {
      to_user_email: @regular_user.email
    }

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "Only club owners can transfer ownership.", flash[:alert]
  end

  test "should allow super admin to initiate transfer" do
    login_as_super_admin
    target_email = @regular_user.email

    assert_difference "OwnershipTransfer.count", 1 do
      post initiate_transfer_admin_club_settings_path(@club), params: {
        to_user_email: target_email
      }
    end

    assert_redirected_to admin_club_settings_path(@club)
  end

  test "should handle non-existent user in transfer initiation" do
    login_as_club_admin
    post initiate_transfer_admin_club_settings_path(@club), params: {
      to_user_email: "nonexistent@example.com"
    }

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "User with email nonexistent@example.com not found.", flash[:alert]
  end

  test "should cancel existing transfer when initiating new one" do
    login_as_club_admin

    # Create existing transfer
    existing_transfer = @club.ownership_transfers.create!(
      from_user: @club_admin,
      to_user_email: "old@example.com"
    )

    post initiate_transfer_admin_club_settings_path(@club), params: {
      to_user_email: @regular_user.email
    }

    existing_transfer.reload
    assert existing_transfer.cancelled?
  end

  test "should cancel ownership transfer as initiator" do
    login_as_club_admin

    # Clear any existing transfers first
    @club.ownership_transfers.destroy_all

    transfer = @club.ownership_transfers.create!(
      from_user: @club_admin,
      to_user_email: @regular_user.email
    )

    delete cancel_transfer_admin_club_settings_path(@club)

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "Ownership transfer cancelled.", flash[:notice]

    transfer.reload
    assert transfer.cancelled?
  end

  test "should allow super admin to cancel any transfer" do
    login_as_super_admin

    transfer = @club.ownership_transfers.create!(
      from_user: @club_admin,
      to_user_email: @regular_user.email
    )

    delete cancel_transfer_admin_club_settings_path(@club)

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "Ownership transfer cancelled.", flash[:notice]
  end

  test "should prevent unauthorized user from cancelling transfer" do
    login_as(@club_operator)

    transfer = @club.ownership_transfers.create!(
      from_user: @club_admin,
      to_user_email: @regular_user.email
    )

    delete cancel_transfer_admin_club_settings_path(@club)

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "You cannot cancel this transfer.", flash[:alert]
  end

  test "should soft delete club as owner" do
    login_as_club_admin

    patch soft_delete_admin_club_settings_path(@club)

    assert_redirected_to admin_clubs_path
    assert_equal "Club '#{@club.name}' has been deleted.", flash[:notice]

    @club.reload
    assert @club.deleted?
  end

  test "should allow super admin to soft delete any club" do
    login_as_super_admin

    patch soft_delete_admin_club_settings_path(@club)

    assert_redirected_to admin_clubs_path
    assert_equal "Club '#{@club.name}' has been deleted.", flash[:notice]
  end

  test "should prevent unauthorized user from soft deleting club" do
    login_as(@club_operator)

    patch soft_delete_admin_club_settings_path(@club)

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "Not authorized to delete this club.", flash[:alert]
  end

  test "should restore club as super admin" do
    login_as_super_admin
    @club.soft_delete!

    patch restore_admin_club_settings_path(@club)

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "Club '#{@club.name}' has been restored.", flash[:notice]

    @club.reload
    assert_not @club.deleted?
  end

  test "should prevent non-super admin from restoring club" do
    login_as_club_admin
    @club.soft_delete!

    patch restore_admin_club_settings_path(@club)

    assert_redirected_to admin_club_settings_path(@club)
    assert_equal "Only platform administrators can restore clubs.", flash[:alert]
  end

  test "should hard delete club as super admin" do
    login_as_super_admin
    club_name = @club.name

    assert_difference "Club.unscoped.count", -1 do
      delete hard_delete_admin_club_settings_path(@club)
    end

    assert_redirected_to admin_clubs_path
    assert_equal "Club '#{club_name}' has been permanently deleted.", flash[:notice]
  end

  test "should prevent non-super admin from hard deleting club" do
    login_as_club_admin

    delete hard_delete_admin_club_settings_path(@club)

    assert_redirected_to admin_clubs_path
    assert_equal "Only platform administrators can permanently delete clubs.", flash[:alert]
  end

  private

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

  def login_as_regular_user
    post login_path, params: {
      email: @regular_user.email,
      password: "roger123!"
    }
  end

  def login_as(user)
    post login_path, params: {
      email: user.email,
      password: "roger123!"
    }
  end
end
