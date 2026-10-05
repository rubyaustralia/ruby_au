require "rails_helper"

RSpec.describe "Password reset", type: :feature do
  scenario "submits reset requests outside Turbo" do
    visit new_user_password_path

    expect(page).to have_css('form[data-turbo="false"]')
  end
end
