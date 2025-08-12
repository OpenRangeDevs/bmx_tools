require "test_helper"

class ToolPermissionTest < ActiveSupport::TestCase
  test "should create valid tool permission" do
    user = User.create!(email: "test@example.com", password: "password123")
    club = clubs(:calgary_bmx)

    permission = ToolPermission.new(
      user: user,
      tool: "race_management",
      role: "club_admin",
      club: club
    )

    assert permission.valid?
    assert permission.save
  end

  test "should require user" do
    permission = ToolPermission.new(
      tool: "race_management",
      role: "club_admin",
      club: clubs(:calgary_bmx)
    )

    assert_not permission.valid?
    assert_includes permission.errors[:user], "can't be blank"
  end

  test "should require tool" do
    user = User.create!(email: "test@example.com", password: "password123")
    permission = ToolPermission.new(
      user: user,
      role: "club_admin",
      club: clubs(:calgary_bmx)
    )
    permission.tool = nil  # Explicitly set to nil to test validation

    assert_not permission.valid?
    assert_includes permission.errors[:tool], "can't be blank"
  end

  test "should require role" do
    user = User.create!(email: "test@example.com", password: "password123")
    permission = ToolPermission.new(
      user: user,
      tool: "race_management",
      club: clubs(:calgary_bmx)
    )

    assert_not permission.valid?
    assert_includes permission.errors[:role], "can't be blank"
  end

  test "should enforce unique user/tool/club combination" do
    user = User.create!(email: "test@example.com", password: "password123")
    club = clubs(:calgary_bmx)

    ToolPermission.create!(
      user: user,
      tool: "race_management",
      role: "club_admin",
      club: club
    )

    duplicate = ToolPermission.new(
      user: user,
      tool: "race_management",
      role: "club_operator",
      club: club
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "has already been taken"
  end

  test "super_admin should have nil club" do
    user = User.create!(email: "test@example.com", password: "password123")

    permission = ToolPermission.new(
      user: user,
      tool: "race_management",
      role: "super_admin",
      club: nil
    )

    assert permission.valid?
  end

  test "super_admin should not have club assigned" do
    user = User.create!(email: "test@example.com", password: "password123")

    permission = ToolPermission.new(
      user: user,
      tool: "race_management",
      role: "super_admin",
      club: clubs(:calgary_bmx)
    )

    assert_not permission.valid?
    assert_includes permission.errors[:club], "must be blank for super_admin role"
  end

  test "club_admin should have club assigned" do
    user = User.create!(email: "test@example.com", password: "password123")

    permission = ToolPermission.new(
      user: user,
      tool: "race_management",
      role: "club_admin",
      club: nil
    )

    assert_not permission.valid?
    assert_includes permission.errors[:club], "must be present for non-super_admin roles"
  end

  test "club_operator should have club assigned" do
    user = User.create!(email: "test@example.com", password: "password123")

    permission = ToolPermission.new(
      user: user,
      tool: "race_management",
      role: "club_operator",
      club: nil
    )

    assert_not permission.valid?
    assert_includes permission.errors[:club], "must be present for non-super_admin roles"
  end

  test "enum values should work correctly" do
    permission = tool_permissions(:super_admin_permission)

    assert permission.race_management?
    assert permission.super_admin?
    assert_not permission.club_admin?
    assert_not permission.club_operator?
  end
end
