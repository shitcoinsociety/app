require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "requesting a sign-in link creates a user and queues the email" do
    assert_difference("User.count", 1) do
      assert_enqueued_emails 2 do
        post session_path, params: { session: { email: "new@example.com" } }
      end
    end

    assert_redirected_to new_user_path(magic_link_sent: true)
    user = User.find_by!(email: "new@example.com")
    assert user.login_token_digest.present?
    assert user.login_token_expires_at.future?
  end

  test "requesting a sign-in link for an existing user does not create a duplicate" do
    assert_enqueued_emails 1 do
      assert_no_difference("User.count") do
        post session_path, params: { session: { email: users(:one).email } }
      end
    end

    assert_redirected_to new_user_path(magic_link_sent: true)
    assert users(:one).reload.login_token_digest.present?
  end

  test "a valid magic link signs in the user and consumes the token" do
    user = users(:one)
    token = user.issue_login_token!

    get magic_link_session_path(token: token)

    assert_redirected_to root_path
    assert_equal user.id, session[:user_id]
    assert_nil user.reload.login_token_digest
  end

  test "an invalid magic link does not sign in the user" do
    user = users(:one)

    get magic_link_session_path(token: "invalid")

    assert_redirected_to root_path
    assert_nil session[:user_id]
    assert_equal "This sign-in link is invalid or has expired.", flash[:alert]
  end
end
