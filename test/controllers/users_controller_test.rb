require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "index returns users in batches with a cursor and total count" do
    User.insert_all!((1..40).map do |id|
      { id: id, email: "pagination-#{id}@example.com", name: "Degen #{id}", password_digest: "unused" }
    end)

    headers = { "X-Inertia" => "true", "X-Inertia-Version" => InertiaRails.configuration.version.to_s }
    get users_path, headers: headers
    assert_response :success
    first_page = response.parsed_body.fetch("props")
    assert_equal 20, first_page.fetch("users").size
    assert_equal 41, first_page.fetch("user_count")
    assert_equal 20, first_page.fetch("next_cursor")

    get users_path(after: first_page.fetch("next_cursor")), headers: headers
    assert_response :success
    second_page = response.parsed_body.fetch("props")
    assert_equal (21..40).to_a, second_page.fetch("users").map { |user| user.fetch("id") }
    assert_equal 40, second_page.fetch("next_cursor")

    get users_path(after: second_page.fetch("next_cursor")), headers: headers
    assert_response :success
    last_page = response.parsed_body.fetch("props")
    assert_equal [ users(:one).id ], last_page.fetch("users").map { |user| user.fetch("id") }
    assert_nil last_page.fetch("next_cursor")
  end

  test "index rejects invalid cursors" do
    [ "0", "-1", "abc", "9223372036854775808", "9" * 50 ].each do |cursor|
      get users_path(after: cursor)
      assert_response :bad_request
    end
  end

  test "index has no next cursor when the last batch is full" do
    User.insert_all!((1..19).map do |id|
      { id: id, email: "pagination-#{id}@example.com", name: "Degen #{id}", password_digest: "unused" }
    end)

    get users_path, headers: { "X-Inertia" => "true", "X-Inertia-Version" => InertiaRails.configuration.version.to_s }
    assert_response :success
    props = response.parsed_body.fetch("props")
    assert_equal 20, props.fetch("users").size
    assert_nil props.fetch("next_cursor")
  end

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
