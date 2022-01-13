require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "users can log in" do
    login_as(users(:empty))
    find("#user-menu-button").click

    assert page.has_button?("Sign out")
  end

  private

  def login_as(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"

    click_button "Sign in"
  end
end
