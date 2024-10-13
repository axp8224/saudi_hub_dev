require 'rails_helper'

RSpec.feature "HelpPage", type: :feature do
  
  before do
    omniauth_mock_auth_hash
    visit new_user_session_path
    click_button "Log in with Google"
    click_button "I Accept"
  end

  scenario "User accesses the help page" do
    visit help_path()

    expect(page).to have_content("How to Use This Website")
  end

end