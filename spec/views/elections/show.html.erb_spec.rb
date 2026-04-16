require 'rails_helper'

RSpec.describe "elections/show", type: :view do
  before(:each) do
    assign(:election, FactoryBot.create(:election, title: "Test Election"))
    assign(:ballot, Ballot.new)
  end

  it "renders the election title" do
    render
    expect(rendered).to match /Test Election/
  end
end
