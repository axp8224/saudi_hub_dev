require 'rails_helper'

RSpec.feature "DocumentationPage", type: :feature do

  around do |example|
    if example.metadata[:not_admin]
      login_as_non_admin
    else 
      login_as_admin
    end

    example.run
  end

  def login_as_non_admin
    omniauth_mock_auth_hash
    visit new_user_session_path
    click_button 'Log in with Google'
    click_button 'I Accept'
  end

  def login_as_admin
    omniauth_mock_auth_hash_ADMIN
    visit new_user_session_path
    click_button 'Log in with Google'
    click_button 'I Accept'
  end

  scenario "Admin accesses the documentation page" do
    visit documentation_path

    expect(page).to have_content(t('pages.documentation.title'))
  end

  scenario "User accesses the documentation page", not_admin: true do 
    visit documentation_path

    expect(page).to have_content(t('flash.admin.access_denied'))
  end

end