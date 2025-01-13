require 'rails_helper'

RSpec.describe "devise/mailer/confirmation_instructions.html.erb", type: :view do
  include Rails.application.routes.url_helpers

  let(:user) { create(:user, full_name: "John Doe") }
  let(:token) { "fake_token" }

  before do
    assign(:resource, user)
    assign(:token, token)

    render
  end

  it "displays the preheader text" do
    expect(rendered).to include("Confirm my membership")
  end

  it "displays the welcome message with the user's full name" do
    expect(rendered).to match(/Welcome John Doe!/)
  end

  it "displays the confirmation instructions" do
    expect(rendered).to match(/To confirm both your email address and your membership for Ruby Australia, please follow the link below:/)
  end

  it "displays the confirmation link" do
    expect(rendered).to have_link('Confirm my membership', href: user_confirmation_url(confirmation_token: token))
  end

  it "displays the Slack community invitation" do
    expect(rendered).to have_link('Slack', href: slack_url)
  end
end
