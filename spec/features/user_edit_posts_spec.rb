require 'rails_helper'

RSpec.feature 'UserEditPosts', type: :feature do
  let(:user) do
    user = User.find_or_initialize_by(email: 'sample@example.com')
    user.assign_attributes(
      full_name: 'Initial Name',
      grad_year: 2022,
      bio: 'Initial bio.',
      major: Major.find_or_create_by(name: 'Computer Science'),
      class_year: ClassYear.find_or_create_by(name: 'Senior')
    )
    user.save!
    user
  end

  before do
    omniauth_mock_auth_hash
    visit new_user_session_path
    click_button 'Log in with Google'
    click_button 'I Accept'
  end

  scenario 'user edits a pending post' do
    pending_post = Resource.where(author: user, status: 'pending')[0]
    old_description = pending_post.description

    visit edit_resource_path(pending_post)

    expect(page).to have_content(t('resources.edit.title'))
    expect(page).to have_content(pending_post.title)

    new_description = 'Updated sample resource description.'
    fill_in t('resources.description'), with: new_description

    click_button t('resources.edit.update')

    expect(page).to have_current_path(posts_user_path(user)) # redirect back to view my posts

    expect(page).not_to have_content(old_description)

    first(:link, 'Last').click

    expect(page).to have_content(new_description)
  end

  scenario 'update fails' do
    pending_post = Resource.where(author: user, status: 'pending')[0]
    old_description = pending_post.description

    visit edit_resource_path(pending_post)

    expect(page).to have_content(t('resources.edit.title'))
    expect(page).to have_content(pending_post.title)

    new_description = 'Updated sample resource description.'
    fill_in t('resources.description'), with: new_description

    allow_any_instance_of(Resource).to receive(:update).and_return(false)

    click_button t('resources.edit.update')

    expect(page).to have_content(t('flash.resource.edit.update_failed'))
  end

  scenario 'user edits an active post' do
    active_post = Resource.where(author: user, status: 'active')[0]

    visit edit_resource_path(active_post)

    expect(page).to have_content(t('flash.resource.edit.only_pending'))
  end

  scenario "user edits someone else's post" do
    other_user = User.find_by(email: 'sample2@example.com')
    restaurant_type = ResourceType.find_by(title: 'Restaurants')
    other_post = Resource.create(title: 'someone else',
                                 resource_type: restaurant_type,
                                 description: "someone else's post",
                                 author: other_user,
                                 status: 'pending')

    visit edit_resource_path(other_post)

    expect(page).to have_content(t('flash.resource.edit.only_your_posts'))
  end
end
