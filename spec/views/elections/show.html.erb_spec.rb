require 'rails_helper'

RSpec.describe "elections/show", type: :view do
  before(:each) do
    assign(:election, Election.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
