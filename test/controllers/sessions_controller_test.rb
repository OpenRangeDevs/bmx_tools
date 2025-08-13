require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login page" do
    get login_path
    assert_response :success
    assert_select "h2", "Sign in to BMX Tools"
    assert_select "input[type='email']"
    assert_select "input[type='password']"
  end

  test "should login with valid credentials" do
    user = users(:super_admin)

    post login_path, params: {
      email: user.email,
      password: TEST_PASSWORD
    }

    # Super admin should redirect to admin dashboard and set session
    assert_equal user.id, session[:user_id]
  end

  test "should redirect club admin to club page after login" do
    user = users(:club_admin)

    post login_path, params: {
      email: user.email,
      password: TEST_PASSWORD
    }

    assert_redirected_to club_admin_path(clubs(:airdrie_bmx))
    assert_equal user.id, session[:user_id]
  end

  test "should not login with invalid email" do
    post login_path, params: {
      email: "nonexistent@example.com",
      password: "password123"
    }

    assert_response :success
    assert_nil session[:user_id]
    assert_select ".alert", /Invalid email or password/
  end

  test "should not login with invalid password" do
    user = users(:super_admin)

    post login_path, params: {
      email: user.email,
      password: "wrongpassword"
    }

    assert_response :success
    assert_nil session[:user_id]
    assert_select ".alert", /Invalid email or password/
  end

  test "should logout successfully" do
    user = users(:super_admin)

    # Login first
    post login_path, params: {
      email: user.email,
      password: TEST_PASSWORD
    }
    assert_equal user.id, session[:user_id]

    # Then logout
    delete logout_path

    assert_redirected_to root_path
    assert_nil session[:user_id]
    follow_redirect!
    assert_select ".alert", /Successfully logged out/
  end
end
