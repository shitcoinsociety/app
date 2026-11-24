require "test_helper"

class UserTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "default name and handle use the user's id before and after saving" do
    user = User.new(email: "new@example.com")

    assert user.valid?
    assert_not_nil user.id
    assert_equal "Degen ##{user.id}", user.name
    assert_equal "degen-#{user.id}", user.handle

    user.save!
    user.reload
    assert_equal "Degen ##{user.id}", user.name
    assert_equal "degen-#{user.id}", user.handle
  end

  test "custom name and handle are preserved" do
    user = User.create!(email: "custom@example.com", name: "Custom", handle: "custom")

    assert_equal "Custom", user.reload.name
    assert_equal "custom", user.handle
  end

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
