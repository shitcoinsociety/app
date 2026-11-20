require "test_helper"

class UserTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "login tokens can only be consumed once" do
    user = users(:one)
    token = user.issue_login_token!

    assert user.consume_login_token(token)
    assert_nil user.reload.login_token_digest
    assert_not user.consume_login_token(token)
  end

  test "expired login tokens cannot be consumed" do
    user = users(:one)
    token = user.issue_login_token!
    user.update!(login_token_expires_at: 1.second.ago)

    assert_not user.consume_login_token(token)
    assert user.reload.login_token_digest.present?
  end
end
