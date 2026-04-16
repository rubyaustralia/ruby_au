require 'rails_helper'

RSpec.describe "elections/index", type: :view do
  before(:each) do
    assign(:current_elections, [
             FactoryBot.create(:election, :open, title: "Election 1"),
             FactoryBot.create(:election, :open, title: "Election 2")
           ])
    assign(:closed_elections, [
             FactoryBot.create(:election, :closed, title: "Closed Election")
           ])
  end

  it "renders a list of elections" do
    render
    expect(rendered).to match /Election 1/
    expect(rendered).to match /Election 2/
    expect(rendered).to match /Closed Election/
  end
end
