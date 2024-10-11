require 'rails_helper'

RSpec.feature "UserProfile", type: :feature do

  let(:user) do
    User.find_by(email: 'sample@example.com') do |u|
      u.full_name = "Initial Name"
      u.grad_year = 2022
      u.bio = "Initial bio."
      u.major = Major.find_by(name: 'Computer Science')
      u.class_year = ClassYear.find_by(name: 'Senior')
      user.save!
    end
  end
  
  before do
    omniauth_mock_auth_hash
    visit new_user_session_path
    click_button "Log in with Google"
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
    expect(page).to have_field('Graduation Year', with: user.grad_year)
    expect(page).to have_field('About Me', with: user.bio)
    
    fill_in 'Full Name', with: 'Updated Name'
    fill_in 'Graduation year', with: '2023'
    fill_in 'About Me', with: 'Updated bio here.'
    select 'Junior', from: 'Classification'
    click_button 'Update profile'

    expect(page).to have_content('Profile updated successfully!')
    user.reload
    expect(user.full_name).to eq 'Updated Name'
    expect(user.grad_year).to eq 2023
    expect(user.bio).to eq 'Updated bio here.'
  end
end
