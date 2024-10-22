require 'rails_helper'

RSpec.feature "UserEditPosts", type: :feature do

  let(:user) do
    user = User.find_or_initialize_by(email: 'sample@example.com')
    user.assign_attributes(
      full_name: "Initial Name",
      grad_year: 2022,
      bio: "Initial bio.",
      major: Major.find_or_create_by(name: 'Computer Science'),
      class_year: ClassYear.find_or_create_by(name: 'Senior')
    )
    user.save!
    user
  end
  
  before do
    omniauth_mock_auth_hash
    visit new_user_session_path
    click_button "Log in with Google"
    click_button "I Accept"
  end

  scenario "user edits a pending post" do 
    pending_post = Resource.where(author: user, status: 'pending')[0]

    visit edit_resource_path(pending_post)

    expect(page).to have_content(t('resources.edit.title'))
    expect(page).to have_content(pending_post.title)
  end

  scenario "user edits an active post" do 
    active_post = Resource.where(author: user, status: 'active')[0]

    visit edit_resource_path(active_post)

    expect(page).to have_content(t('flash.resource.edit.only_pending'))
  end

  scenario "user edits someone else's post" do 
    other_user = User.find_by(email: "sample2@example.com")
    restaurant_type = ResourceType.find_by(title: 'Restaurants')
    other_post = Resource.create(title: "someone else", 
        resource_type: restaurant_type,
        description: "someone else's post",
        author: other_user,
        status: 'pending')
    puts "Other post: #{other_post}"

    visit edit_resource_path(other_post)

    expect(page).to have_content(t("flash.resource.edit.only_your_posts"))

  end

end