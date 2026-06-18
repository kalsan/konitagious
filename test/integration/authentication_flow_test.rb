require "test_helper"

class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      first_name: "Flow", last_name: "Tester", email: "flow@example.com",
      password: "secret123", password_confirmation: "secret123"
    )
  end

  test "login page renders on the auth layout" do
    get "/login"
    assert_response :success
    assert_select "form input[name='session[email]']"
    assert_select "nav.navbar", count: 0
  end

  test "protected component redirects unauthenticated user to login" do
    get "/users"
    assert_redirected_to "/login"
  end

  test "valid credentials start a session and allow access" do
    post "/login", params: { session: { email: "flow@example.com", password: "secret123", stay_signed_in: "1" } }
    assert_redirected_to root_url
    assert cookies[:session_id].present?

    get "/users"
    assert_response :success
  end

  test "wrong credentials are rejected" do
    post "/login", params: { session: { email: "flow@example.com", password: "nope" } }
    assert_redirected_to "/login"
    assert cookies[:session_id].blank?
  end

  test "logout terminates the session" do
    post "/login", params: { session: { email: "flow@example.com", password: "secret123" } }
    assert cookies[:session_id].present?

    delete "/logout"
    assert_redirected_to "/login"
    assert cookies[:session_id].blank?
  end

  test "forgot password sends reset mail for a known address" do
    assert_enqueued_email_with PasswordsMailer, :reset, args: [ @user ] do
      post "/passwords/forgot", params: { password: { email: "flow@example.com" } }
    end
    assert_redirected_to "/login"
  end

  test "forgot password reveals nothing for an unknown address" do
    assert_no_enqueued_emails do
      post "/passwords/forgot", params: { password: { email: "ghost@example.com" } }
    end
    assert_redirected_to "/login"
  end

  test "reset page renders for a valid token and rejects an invalid one" do
    token = @user.generate_token_for(:password_reset)
    get "/passwords/#{token}/reset"
    assert_response :success
    assert_select "form input[name='password[password_confirmation]']"

    get "/passwords/not-a-token/reset"
    assert_redirected_to "/passwords/forgot"
  end

  test "reset updates the password and invalidates sessions" do
    @user.sessions.create!
    token = @user.generate_token_for(:password_reset)
    patch "/passwords/#{token}/reset", params: { password: { password: "brandnew1", password_confirmation: "brandnew1" } }
    assert_redirected_to "/login"
    assert_equal 0, @user.sessions.count
    assert @user.reload.authenticate("brandnew1")
  end
end
