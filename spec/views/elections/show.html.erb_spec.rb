require 'rails_helper'

RSpec.describe "elections/show", type: :view do
  before(:each) do
    assign(:election, Election.create!(title: "Test Election", point_scale: 10, vacancies: 1))
    assign(:ballot, Ballot.new)
  end

  it "renders attributes in <p>" do
    render
  end
end
