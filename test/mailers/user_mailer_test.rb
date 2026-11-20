require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome links to the founder video" do
    user = users(:one)
    email = UserMailer.welcome(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ user.email ], email.to
    assert_equal "Welcome to Shitcoin Society", email.subject
    assert_includes email.body.encoded, "https://youtu.be/rjz4Vh_msMw"
  end

  test "magic login email contains the sign-in link and expiry" do
    user = users(:one)
    token = "test-token"
    email = UserMailer.magic_login(user, token)

    assert_equal [ user.email ], email.to
    assert_equal "Your Shitcoin Society sign-in link", email.subject
    assert_includes email.body.encoded, token
    assert_includes email.body.encoded, "/session/magic_link?token=#{token}"
    assert_includes email.body.encoded, "15 minutes"
  end
end
