require 'rails_helper'

RSpec.describe "elections/new", type: :view do
  before do
    assign(:election, Election.new(title: "New Election", point_scale: 10, vacancies: 1))
    assign(:ballot, Ballot.new)
  end

  it "renders new election form" do
    render

    assert_select "form[action=?][method=?]", elections_path, "post" do
    end
  end
end
