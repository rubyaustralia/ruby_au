require 'rails_helper'

RSpec.describe "elections/edit", type: :view do
  let(:election) {
    Election.create!()
  }

  before(:each) do
    assign(:election, election)
  end

  it "renders the edit election form" do
    render

    assert_select "form[action=?][method=?]", election_path(election), "post" do
    end
  end
end
