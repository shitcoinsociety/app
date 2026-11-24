require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "renders a user by id" do
    get user_path(users(:one))

    assert_response :success
  end

  test "renders a user by handle" do
    user = users(:one)
    user.update!(handle: "degen-one")

    get user_handle_path(user.handle)

    assert_response :success
  end
end
