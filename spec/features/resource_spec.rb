require 'rails_helper'

RSpec.feature 'Resources', type: :feature do
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
    click_button 'Log in with Google'
    click_button 'I Accept'
  end

  scenario 'User views all active resources' do
    visit resources_path

    expect(page).to have_content('Resources')

    active_resources.limit(10).each do |resource|
      expect(page).to have_content(resource.title)
    end

    pending_resources.each do |resource|
      expect(page).not_to have_content(resource.title)
    end
  end

  scenario 'User filters resources by type' do
    visit resources_path

    click_link restaurant_type.title

    active_restaurant_resources.each do |resource|
      expect(page).to have_content(resource.title)
    end

    # active_apartment_resources.each do |resource|
    #  expect(page).not_to have_content(resource.title)
    # end
  end

  scenario 'User sees all resource types in sidebar' do
    visit resources_path

    expect(page).to have_content('All Resources')
    ResourceType.all.each do |resource_type|
      expect(page).to have_content(resource_type.title)
    end
  end

  scenario 'User views a specific resource page' do
    visit resources_path

    resource = active_resources.first

    first(:link, 'Read More', href: resource_path(resource)).click

    expect(page).to have_content(resource.title)
    expect(page).to have_content(resource.description)
    expect(page).to have_content(resource.resource_type.title)
    expect(page).to have_content('Written by:')
  end

  scenario 'User searches for a non-existent resource and sees no results' do
    visit resources_path

    fill_in 'search', with: 'NonExistentResourceName123'
    click_button 'Search'

    expect(page).to have_content('No results match your search or filter criteria.')

    Resource.where.not('title ILIKE :search OR description ILIKE :search',
                       search: '%NonExistentResourceName123%').each do |resource|
      expect(page).not_to have_content(resource.title)
      expect(page).not_to have_content(resource.description)
    end
  end

  #=begin  =endscenario 'User creates a new resource' do
  #  visit new_resource_path
  #
  #  fill_in 'Title', with: 'Sample Resource'
  #  fill_in 'Description', with: 'This is a sample resource description.'
  #  select restaurant_type.title, from: 'Resource type'
  #  attach_file 'Images', Rails.root.join('spec/fixtures/files/sample_image.jpg')
  #
  #  click_button 'Create New Resourcesource'
  #
  #  expect(page).to have_content('Resource was successfully created.')
  #
  #  fill_in 'search', with: 'Sample Resource'
  #  click_button 'Search'
  #
  #  expect(page).to have_content('Sample Resource')
  #  expect(page).to have_content('This is a sample resource description.')
  #  expect(page).to have_content(restaurant_type.title)
  # end

  scenario 'User fails to create a new resource with an invalid file' do
    visit new_resource_path

    fill_in 'Title', with: 'Sample Resource'
    fill_in 'Description', with: 'This is a sample resource description.'
    select restaurant_type.title, from: 'Type'
    attach_file 'Images', Rails.root.join('spec/fixtures/files/invalid_file.txt')

    click_button 'Create New Resource'

    expect(page).to have_content('must be a JPG, JPEG, PNG, or GIF')
  end

  scenario 'User fails to create a new resource with invalid data' do
    visit new_resource_path

    click_button 'Create New Resource'

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
  end

  scenario 'User searches for resources by address' do
    visit resources_path

    fill_in 'address', with: '400 Bizzell St, College Station, TX 77840'
    click_button 'Search'

    expect(page).to have_content('miles')
  end

  scenario 'User searches for resources within a specific radius' do
    visit resources_path

    fill_in 'address', with: '400 Bizzell St, College Station, TX 77840'
    fill_in 'radius', with: '10' # radius in miles
    click_button 'Search'

    all('.distance').each do |distance_element|
      distance = distance_element.text.split.first.to_f
      expect(distance).to be <= 10
    end
  end
end
