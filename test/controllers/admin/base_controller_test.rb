require "test_helper"

class Admin::BaseControllerTest < ActionDispatch::IntegrationTest
  test "should require authentication for admin access" do
    get admin_root_path
    assert_redirected_to login_path
    assert_equal "Please sign in to continue", flash[:alert]
  end

  test "should require super admin role" do
    user = users(:club_admin)
    post login_path, params: { email: user.email, password: TEST_PASSWORD }

    get admin_root_path
    assert_redirected_to root_path
    assert_equal "Access denied", flash[:alert]
  end

  test "should allow super admin access" do
    user = users(:super_admin)
    post login_path, params: { email: user.email, password: TEST_PASSWORD }

    get admin_root_path
    assert_response :success
  end
end
