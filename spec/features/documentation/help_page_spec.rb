require 'rails_helper'

RSpec.feature "HelpPage", type: :feature do

  scenario "User accesses the help page" do
    visit help_path

    expect(page).to have_content(t('pages.help.title'))
  end

end