require 'rails_helper'

RSpec.feature "UserProfile", type: :feature do

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

  scenario "User views their profile" do
    visit user_profile_path(user)

    expect(page).to have_content('Your Profile')
    expect(page).to have_content(user.full_name)
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.major.name)
    expect(page).to have_content(user.class_year.name)
    expect(page).to have_content(user.grad_year)
    expect(page).to have_content(user.bio)
  end

  scenario "User edits their profile" do
    visit edit_user_profile_path(user)

    expect(page).to have_field('Full Name', with: user.full_name)
    expect(page).to have_selector("input[type='email'][readonly][value='#{user.email}']")    
    expect(page).to have_field('Graduation Year', with: user.grad_year.to_s)
    expect(page).to have_field('About Me', with: user.bio)
    
    fill_in 'Full Name', with: 'Updated Name'
    fill_in 'Graduation Year', with: '2023'
    fill_in 'About Me', with: 'Updated bio here.'

    save_and_open_page
    expect(page).to have_select('user_class_year_id', visible: true)
    select 'Junior', from: 'user_class_year_id' 

    expect(page).to have_select('user_major_id', visible: true)
    select 'Accounting', from: 'user_major_id' 

    click_button 'Update Profile'

    expect(page).to have_content('Profile updated successfully!')
    user.reload
    expect(user.full_name).to eq 'Updated Name'
    expect(user.grad_year).to eq 2023
    expect(user.bio).to eq 'Updated bio here.'
    
    # expect(page).to have_css('#user_class_year_id.form-control')
    # selected_option = find('#user_class_year_id').find('option[selected]').text
    expect(user.class_year.name).to eq 'Junior'
    expect(user.major.name).to eq 'Accounting'
  end

  scenario "User views some else's profile" do 
    visit users_path 

    other_user = User.find_by(email: "sample2@example.com")

    fill_in 'search', with: other_user.email
    click_button 'Search'

    expect(page).to have_content(other_user.full_name)

    click_on 'View Profile'

    expect(page).to have_current_path(user_path(other_user))
    expect(page).to have_content(other_user.full_name)

    expect(page).not_to have_content(t('users.edit.edit_your_profile')) # I should not be able to edit someone else's profile.
  end

  scenario "User tries to edit someone else's profile" do 
    other_user = User.find_by(email: "sample2@example.com")

    visit edit_user_profile_path(other_user)

    expect(page).to have_content(t('flash.profile.edit.only_your_profile')) 
  end

end
