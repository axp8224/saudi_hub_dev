require 'rails_helper'

RSpec.feature "Resources", type: :feature do
  let(:user) { User.find_by(email: 'sample@example.com') }
  let(:restaurant_type) { ResourceType.find_by(title: 'Restaurants') }
  let(:apartment_type) { ResourceType.find_by(title: 'Apartments') }
  let(:active_resources) { Resource.where(status: 'active') }
  let(:pending_resources) { Resource.where(status: 'pending') }
  let(:active_restaurant_resources) { Resource.where(resource_type: restaurant_type, status: 'active') }
  let(:active_apartment_resources) { Resource.where(resource_type: apartment_type, status: 'active') }

  before do
    omniauth_mock_auth_hash
    visit new_user_session_path
    click_button "Log in with Google"
  end

  scenario "User views all active resources" do
    visit resources_path
    
    expect(page).to have_content('Resources')
    active_resources.each do |resource|
      expect(page).to have_content(resource.title)
    end
    pending_resources.each do |resource|
      expect(page).not_to have_content(resource.title)
    end
  end

  scenario "User filters resources by type" do
    visit resources_path
    click_link restaurant_type.title

    active_restaurant_resources.each do |resource|
      expect(page).to have_content(resource.title)
    end
    active_apartment_resources.each do |resource|
      expect(page).not_to have_content(resource.title)
    end
  end

  scenario "User sees all resource types in sidebar" do
    visit resources_path

    expect(page).to have_content('All Resources')
        ResourceType.all.each do |resource_type|
        expect(page).to have_content(resource_type.title)
    end
  end

  scenario "Admin sees all pending resources for approval" do 
    # can filter resources on status
    visit admin_resources_path
    select 'pending', from: 'resource_status'

    pending_resources.each do |resource|
      expect(page).to have_content(resource.title)
    end
    active_resources.each do |resource|
      expect(page).not_to have_content(resource.title)
    end
  end

  scenario "Admin can edit resources" do
    # can technically edit any resource as an admin, but here we do pending because it is the most common likely use case.
    visit admin_resources_path
    
    select 'pending', from: 'resource_status'

    original_description = :pending_resources[0]

    expect(page).to have_content(original_description)

    click_link 'Edit Resource', match: :first

    expect(page).to have_content(original_description) # ensure this is the page for the first pending resource

    new_description = 'Updated sample resource description.'
    fill_in 'Description', with: new_description 

    click_button 'Save Resource'

    expect(page).to have_current_path(admin_resources_path) # redirect back to manage resources page

    select 'pending', from: 'resource_status'

    expect(page).not_to have_content(original_description)
    expect(page).to have_content(new_description)
  end

  scenario "Admin can approve resources" do
    # edit status of a resource from pending to active
    visit admin_resources_path
    
    select 'pending', from: 'resource_status'

    original_description = :pending_resources[0]

    expect(page).to have_content(original_description)

    click_link 'Edit Resource', match: :first

    expect(page).to have_content(original_description) # ensure this is the page for the first pending resource

    select 'active', from: 'resource_status'

    click_button 'Save Resource'

    expect(page).to have_current_path(admin_resources_path) # redirect back to manage resources page

    select 'pending', from: 'resource_status'

    expect(page).not_to have_content(original_description)

    select 'active', from: 'resource_status'

    expect(page).to have_content(original_description)
  end

  scenario "Admin can reject resources" do
    # edit status of a resource from pending to archived
    visit admin_resources_path
    
    select 'pending', from: 'resource_status'

    original_description = :pending_resources[0]

    expect(page).to have_content(original_description)

    click_link 'Edit Resource', match: :first

    expect(page).to have_content(original_description) # ensure this is the page for the first pending resource

    select 'archived', from: 'resource_status'

    click_button 'Save Resource'

    expect(page).to have_current_path(admin_resources_path) # redirect back to manage resources page

    select 'pending', from: 'resource_status'

    expect(page).not_to have_content(original_description)

    select 'archived', from: 'resource_status'

    expect(page).to have_content(original_description)
  end

end