require 'rails_helper'

RSpec.feature "ActivityLogging", type: :feature do

  let(:admin) { User.find_by(email: 'admin@example.com') }

  before do
    omniauth_mock_auth_hash 
    visit new_user_session_path
    click_button "Log in with Google"
    click_button "I Accept"
  end

  scenario "Admin edits a resource" do
    # create
    visit new_resource_path
    fill_in 'Title', with: 'Old Title'
    fill_in 'Description', with: 'Old description.'
    select 'Restaurants', from: 'resource_resource_type_id'
    click_button 'Create Resource'
    
    # edit
    created_resource = Resource.find_by(title: "Old Title")
    visit edit_admin_resource_path(created_resource)
    expect(current_path).to eq(edit_admin_resource_path(created_resource))

    fill_in 'Title', with: 'New Title'
    fill_in 'Description', with: 'New Description'
    select 'Active', from: 'resource_status'
    select 'Parks', from: 'resource_resource_type_id'
    click_button 'Save Resource'

    visit admin_logs_path
    expect(page).to have_content('admin@example.com')
    expect(page).to have_content('Updated Resource')
    expect(page).to have_content('New Title')
    expect(page).to have_content('from "Old Title" to "New Title"')
    expect(page).to have_content('from "Old Description" to "New Description"')
    expect(page).to have_content('Status from "Pending" to "Active"')
    expect(page).to have_content('Resource Type from "Restaurants" to "Parks"')
  end
end