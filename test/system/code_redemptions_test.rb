require "application_system_test_case"

class CodeRedemptionsTest < ApplicationSystemTestCase
  test "logged in user can redeem a code" do
    visit "/"
    click_on "Redeem Code"

    assert_text "You must be logged in"

    within("main") do
      fill_in "Email", with: "new@example.com"
      fill_in "Password", with: "password"
      click_on "Sign Up"
    end

    assert_text "logged in"

    click_on "Redeem Code"

    within("main") do
      fill_in "XXX", with: "EXAMPLECODE"
      click_on "Redeem"
    end

    assert_text "Code redeemed successfully"

    assert_text "RST: 1000"

    click_on "Redeem Code"

    within("main") do
      fill_in "XXX", with: "EXAMPLECODE"
      click_on "Redeem"
    end

    assert_text "Code has already been redeemed"
  end
end
