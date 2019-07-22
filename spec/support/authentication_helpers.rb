module AuthenticationHelpers
  def log_in_as(user)
    visit new_user_session_path

    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
    expect(page).to have_content("Log out")
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :feature
end
