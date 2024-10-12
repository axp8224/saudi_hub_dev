require 'rails_helper'

RSpec.feature "UserViewPosts", type: :feature do

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

  scenario "user navigates to their posts" do 
    # create one pending resource and one active resource first
    restaurant_type = ResourceType.find_by(title: 'Restaurants')
    pending_resource = Resource.create( title: "New Pending Resource", 
                                        resource_type: restaurant_type, 
                                        author: user,
                                        description: "A resource that hasn't yet been approved.",
                                        status: "pending")

    active_resource = Resource.create( title: "New Active Resource", 
                                        resource_type: restaurant_type, 
                                        author: user,
                                        description: "A resource that has been approved.",
                                        status: "active") 

    visit posts_user_path(user)

    expect(page).to have_content("New Pending Resource")
    expect(page).to have_content("New Active Resource")
    expect(page).not_to have_content("Piada") # do not display resources not authored by 'user'
  
  end

end