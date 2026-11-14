require "test_helper"

class UserTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "enqueues the welcome email when created" do
    user = User.create!(email: "new-user@example.com")

    assert_enqueued_email_with UserMailer, :welcome, args: [ user ]
  end
end
