require "application_system_test_case"

class UsersPaginationTest < ApplicationSystemTestCase
  test "load more appends users until all are displayed" do
    User.insert_all!((1..40).map do |id|
      { id: id, email: "pagination-#{id}@example.com", name: "Degen #{id}", password_digest: "unused" }
    end)

    visit users_path
    assert_selector ".user-card", count: 20, wait: 20
    assert_text "Sign up to become degen #42"
    assert_no_link "Degen 21"
    page.execute_script("window.usersPaginationPage = true")

    click_button "Load more"
    assert_selector ".user-card", count: 40
    assert_link "Degen 1"
    assert_link "Degen 40"
    assert_text "Sign up to become degen #42"
    assert page.evaluate_script("window.usersPaginationPage")
    assert_equal "/users", page.evaluate_script("window.location.pathname + window.location.search")

    click_button "Load more"
    assert_selector ".user-card", count: 41
    assert_no_button "Load more"
    assert page.evaluate_script("window.usersPaginationPage")
  end
end
