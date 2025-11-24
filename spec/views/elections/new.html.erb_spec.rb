require 'rails_helper'

RSpec.describe "elections/new", type: :view do
  before(:each) do
    assign(:election, Election.new())
  end

  it "renders new election form" do
    render

    assert_select "form[action=?][method=?]", elections_path, "post" do
    end
  end
end
