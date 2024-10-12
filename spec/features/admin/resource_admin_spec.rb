require 'rails_helper'

RSpec.feature 'Resources', type: :feature do
  let(:admin) { User.find_by(email: 'admin@example.com') }
  let(:restaurant_type) { ResourceType.find_by(title: 'Restaurants') }
  let(:apartment_type) { ResourceType.find_by(title: 'Apartments') }
  let(:active_resources) { Resource.where(status: 'active') }
  let(:pending_resources) { Resource.where(status: 'pending') }
  let(:active_restaurant_resources) { Resource.where(resource_type: restaurant_type, status: 'active') }
  let(:active_apartment_resources) { Resource.where(resource_type: apartment_type, status: 'active') }

  before do
    omniauth_mock_auth_hash_ADMIN
    visit new_user_session_path
    click_button 'Log in with Google'
    click_button 'I Accept'
  end

  scenario 'Admin sees all pending resources for approval' do
    # can filter resources on status
    visit admin_resources_path

    expect(page).to have_content('Resource Manager')

    select t('admin.resources.status_pending'), from: 'status'

    click_on 'Search'

    pending_resources.each do |resource|
      expect(page).to have_content(resource.title)
    end
    active_resources.each do |resource|
      expect(page).not_to have_content(resource.title)
    end
  end

  scenario 'Admin can edit resources' do
    # can technically edit any resource as an admin, but here we do pending because it is the most common likely use case.
    visit admin_resources_path

    select t('admin.resources.status_pending'), from: 'status'
    click_on 'Search'

    pending_resource = pending_resources.first
    original_description = pending_resource.description

    expect(page).to have_content(original_description)

    visit edit_admin_resource_path(pending_resource)

    expect(page).to have_content(original_description) # ensure this is the page for the first pending resource

    new_description = 'Updated sample resource description.'
    fill_in 'Description', with: new_description

    click_button 'Save Resource'

    expect(page).to have_current_path(admin_resources_path) # redirect back to manage resources page

    select t('admin.resources.status_pending'), from: 'status'
    click_on 'Search'

    expect(page).not_to have_content(original_description)
    expect(page).to have_content(new_description)
  end

  scenario 'Admin can leave feedback on resources' do 
    visit admin_resources_path

    feedback_message = "Testing feedback in RSpec"

    select t('admin.resources.status_pending'), from: 'status'
    click_on 'Search'

    pending_resource = pending_resources.first
    original_description = pending_resource.description

    expect(page).not_to have_content(feedback_message)

    visit edit_admin_resource_path(pending_resource)

    click_button t('admin.resources.edit.add_feedback')

    fill_in t('resources.feedback'), with: feedback_message

    click_button 'Save Resource'

    expect(page).to have_current_path(admin_resources_path) # redirect back to manage resources page

    select t('admin.resources.status_pending'), from: 'status'
    
    click_on 'Search'

    expect(page).to have_content(feedback_message)
  end

  scenario 'Admin can approve resources' do
    # edit status of a resource from pending to active
    visit admin_resources_path

    select t('admin.resources.status_pending'), from: 'status'

    pending_resources = Resource.where(status: 'pending')

    pending_resource = pending_resources.first
    original_description = pending_resource.description

    expect(page).to have_content(original_description)

    visit edit_admin_resource_path(pending_resource)

    expect(page).to have_content(original_description) # ensure this is the page for the first pending resource

    select t('admin.resources.status_active'), from: 'resource[status]'

    click_button 'Save Resource'

    expect(page).to have_current_path(admin_resources_path) # redirect back to manage resources page

    select t('admin.resources.status_pending'), from: 'status'
    click_on 'Search'

    expect(page).not_to have_content(original_description)

    select t('admin.resources.status_active'), from: 'status'
    click_on 'Search'

    expect(page).to have_content(original_description)
  end

  scenario 'Admin can reject resources' do
    # edit status of a resource from pending to archived
    visit admin_resources_path

    select t('admin.resources.status_pending'), from: 'status'
    click_on 'Search'

    original_description = pending_resources.first.description

    expect(page).to have_content(original_description)

    click_link 'Edit Resource', match: :first

    expect(page).to have_content(original_description) # ensure this is the page for the first pending resource

    select t('admin.resources.status_archived'), from: 'resource[status]'

    click_button 'Save Resource'

    expect(page).to have_current_path(admin_resources_path) # redirect back to manage resources page

    select t('admin.resources.status_pending'), from: 'status'
    click_on 'Search'

    expect(page).not_to have_content(original_description)

    select t('admin.resources.status_archived'), from: 'status'
    click_on 'Search'

    expect(page).to have_content(original_description)
  end
end
