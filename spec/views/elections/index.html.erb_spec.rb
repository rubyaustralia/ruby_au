require 'rails_helper'

RSpec.describe "elections/index", type: :view do
  before(:each) do
    assign(:current_elections, [
             Election.create!(title: "Election 1", point_scale: 10, vacancies: 1),
             Election.create!(title: "Election 2", point_scale: 10, vacancies: 1)
           ])
    assign(:closed_elections, [])
  end

  it "renders a list of elections" do
    render
  end
end
