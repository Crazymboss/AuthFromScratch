require 'rails_helper'

RSpec.describe "ForgotPassword", type: :system do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include Rails.application.routes.url_helpers

  it "allows users to reset password" do
    user = User.create(email: "jdoe@example.com", password: "12345678")
    visit "/"
    click_on "Sign In"
    click_on "Forgot your password?"
    fill_in "user-email", with: "jdoe@email.com"
    click_on "user-reset-submit"
    expect(page).to have_content('If there is an account with that email, we will send you an email with your password reset link.')
    token = user.signed_id(purpose: 'password_reset')
    visit password_reset_edit_path(token: token)
    fill_in 'user-password', with: 'secret1234'
    click_on "user-save"
    expect(page).to have_content('Your password was successfully updated')
    fill_in "user-email", with: "jdoe@email.com"
    fill_in "user-password", with: "secret1234"
    click_on "user-login-submit"

  end
end