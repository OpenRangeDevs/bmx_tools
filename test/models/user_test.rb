require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should create valid user" do
    user = User.new(
      email: "test@example.com",
      password: "password123"
    )
    assert user.valid?
    assert user.save
  end

  test "should require email" do
    user = User.new(password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "should require unique email" do
    User.create!(email: "test@example.com", password: "password123")
    user = User.new(email: "test@example.com", password: "password456")
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "should require valid email format" do
    user = User.new(email: "invalid-email", password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email], "is invalid"
  end

  test "should require password" do
    user = User.new(email: "test@example.com")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "should authenticate with correct password" do
    user = User.create!(email: "test@example.com", password: "password123")
    assert user.authenticate("password123")
    assert_not user.authenticate("wrongpassword")
  end

  test "super_admin? should return true for super admin" do
    user = users(:super_admin)
    assert user.super_admin?
  end

  test "super_admin? should return false for non-super admin" do
    user = users(:club_admin)
    assert_not user.super_admin?
  end

  test "admin_for? should return true for club admin of specific club" do
    user = users(:club_admin)
    club = clubs(:calgary_bmx)
    assert user.admin_for?(club)
  end

  test "admin_for? should return true for super admin for any club" do
    user = users(:super_admin)
    club = clubs(:calgary_bmx)
    assert user.admin_for?(club)
  end

  test "admin_for? should return false for non-admin user" do
    user = User.create!(email: "regular@example.com", password: "password123")
    club = clubs(:calgary_bmx)
    assert_not user.admin_for?(club)
  end

  test "can_manage_races? should return true for users with race_management permissions" do
    user = users(:super_admin)
    assert user.can_manage_races?
  end

  test "can_manage_races? should return false for users without permissions" do
    user = User.create!(email: "regular@example.com", password: "password123")
    assert_not user.can_manage_races?
  end
end
