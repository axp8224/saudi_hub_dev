require 'rails_helper'

RSpec.feature "Resources", type: :feature do
  let(:user) { User.find_by(email: 'sample@example.com') }
  let(:restaurant_type) { ResourceType.find_by(title: 'Restaurants') }
  let(:apartment_type) { ResourceType.find_by(title: 'Apartments') }
  let(:active_resources) { Resource.where(status: 'active') }
  let(:pending_resources) { Resource.where(status: 'pending') }
  let(:restaurant_resources) { Resource.where(resource_type: restaurant_type) }
  let(:apartment_resources) { Resource.where(resource_type: apartment_type) }

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

    restaurant_resources.each do |resource|
      expect(page).to have_content(resource.title)
    end
    apartment_resources.each do |resource|
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
end