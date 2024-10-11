require 'rails_helper'

RSpec.feature 'Privacy Policy', type: :feature do
  scenario 'User signs in and accepts Privacy Policy' do
    omniauth_mock_auth_hash
    visit new_user_session_path
    click_button 'Log in with Google'
    click_button 'I Accept'

    expect(page).to have_content('Edit Your Profile')
  end

  scenario 'User signs in and declines Privacy Policy' do
    omniauth_mock_auth_hash
    visit new_user_session_path
    click_button 'Log in with Google'
    click_button 'Decline'

    expect(page).to have_content('You need to accept the privacy policy to continue')
  end
end
