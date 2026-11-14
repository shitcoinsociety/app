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
end
