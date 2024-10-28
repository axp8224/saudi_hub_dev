require 'rails_helper'

RSpec.feature 'ActivityLogging', type: :feature do
  let(:admin) { User.find_by(email: 'admin@example.com') }
  let(:user) { User.find_by(email: 'sample@example.com') }

  before do
    omniauth_mock_auth_hash_ADMIN
    visit new_user_session_path
    click_button 'Log in with Google'
    click_button 'I Accept'
  end

  scenario 'Admin edits a resource' do
    # create
    visit new_resource_path
    fill_in 'Title', with: 'Old Title'
    fill_in 'Description', with: 'Old Description'
    select 'Restaurants', from: 'resource_resource_type_id'
    click_button 'Create Resource'

    # edit
    created_resource = Resource.find_by(title: 'Old Title')
    visit edit_admin_resource_path(created_resource)
    expect(current_path).to eq(edit_admin_resource_path(created_resource))

    fill_in 'Title', with: 'New Title'
    fill_in 'Description', with: 'New Description'
    select 'Parks', from: 'resource_resource_type_id'
    click_button 'Save Resource'

    visit admin_logs_path
    expect(page).to have_content('admin@example.com')
    expect(page).to have_content('Updated Resource')
    expect(page).to have_content('New Title')
    expect(page).to have_content('from \'Old Title\' to \'New Title\'')
    expect(page).to have_content('from \'Old Description\' to \'New Description\'')
    expect(page).to have_content('resource_type from \'Restaurants\' to \'Parks\'')
  end

  scenario 'Admin changes user to an admin' do
    visit edit_admin_user_path(user)

    select 'admin', from: 'user_role_id'
    click_button 'Update Role'

    visit admin_logs_path
    expect(page).to have_content('admin@example.com')
    expect(page).to have_content('Updated User')
    expect(page).to have_content('Role changed from \'user\' to \'admin\'')
  end

end