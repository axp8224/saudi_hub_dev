require 'rails_helper'

RSpec.feature 'Member Directory', type: :feature do
  let(:users) { User.all }
  let(:user) { User.find_by(email: 'sample@example.com') }
  let(:admin) { User.find_by(email: 'admin@example.com') }
  let(:class_years) { ClassYear.all }
  let(:majors) { Major.all }

  before do
    omniauth_mock_auth_hash
    visit new_user_session_path
    click_button 'Log in with Google'
    click_button 'I Accept'
  end

  scenario 'User views members in Member Directory' do
    visit users_path

    expect(page).to have_content('Member Directory')

    users.limit(10).each do |user|
      expect(page).to have_content(user.full_name)
      expect(page).to have_content(user.major.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.role.name)
      expect(page).to have_content(user.class_year.name)
    end
  end

  scenario 'User filters members by each class year' do
    visit users_path

    class_years.each do |class_year|
      # Select the current class year in the loop
      select class_year.name, from: 'class_year'
      click_button 'Search'

      # Verify only users with the selected class year are displayed
      User.where(class_year:).limit(10).each do |user|
        expect(page).to have_content(user.full_name)
      end

      # Verify users with different class years are not displayed
      User.where.not(class_year:).each do |user|
        expect(page).not_to have_content(user.email)
      end
    end
  end

  scenario 'User filters members by each major' do
    visit users_path

    majors.limit(10).each do |major|
      # Select the current major in the loop
      select major.name, from: 'major'
      click_button 'Search'

      # Verify only users with the selected major are displayed
      User.where(major:).limit(10).each do |user|
        expect(page).to have_content(user.full_name)
      end

      # Verify users with different major are not displayed
      User.where.not(major:).each do |user|
        expect(page).not_to have_content(user.email)
      end
    end
  end

  scenario 'User searches for a non-existent user and sees no results' do
    visit users_path

    fill_in 'search', with: 'NonExistentUserName123'
    click_button 'Search'

    expect(page).to have_content('No results match your search or filter criteria.')

    User.where.not('full_name ILIKE :search OR email ILIKE :search',
                   search: '%NonExistentUserName123%').each do |user|
      expect(page).not_to have_content(user.email)
    end
  end
end
