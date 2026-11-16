require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "redirects back to the page the signup form was submitted from" do
    assert_difference("User.count") do
      post users_path,
        params: { email: "signup-redirect@example.com" },
        as: :json,
        headers: { "X-Inertia-Referer" => "/@buhrmi?tab=about" }
    end

    assert_redirected_to "/@buhrmi?signedup=true&tab=about"
  end

  test "redirects to the root page without a referer" do
    assert_difference("User.count") do
      post users_path, params: { email: "signup-root@example.com" }, as: :json
    end

    assert_redirected_to "/?signedup=true"
  end

  test "shares the signedup flag on every page" do
    get user_handle_path(handle: users(:one).handle), params: { signedup: true }

    assert_inertia_props signedup: true
  end
end
