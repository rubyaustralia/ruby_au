require 'rails_helper'

RSpec.describe "elections/edit", type: :view do
  let(:election) do
    Election.create!(title: "Test Election", point_scale: 10, vacancies: 1)
  end

  before do
    assign(:election, election)
    assign(:ballot, Ballot.new)
  end

  it "renders the edit election form" do
    render

    assert_select "form[action=?][method=?]", election_path(election), "post"
  end
end
