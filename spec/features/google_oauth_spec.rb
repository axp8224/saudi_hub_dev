require 'rails_helper'

RSpec.feature "Google OAuth", type: :feature do
  scenario "User signs in with Google" do
    omniauth_mock_auth_hash
    visit new_user_session_path
    click_button "Log in with Google"

    expect(page).to have_content("Welcome to Saudi Hub!")
  end

  scenario "User fails to sign in with Google" do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    visit new_user_session_path
    click_button "Log in with Google"
    
    expect(page).to have_content("Could not authenticate you from GoogleOauth2 because \"Invalid credentials\".")
  end

end