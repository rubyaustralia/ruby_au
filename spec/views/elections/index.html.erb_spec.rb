require 'rails_helper'

RSpec.describe "elections/index", type: :view do
  before(:each) do
    assign(:elections, [
      Election.create!(),
      Election.create!()
    ])
  end

  it "renders a list of elections" do
    render
    cell_selector = 'div>p'
  end
end
