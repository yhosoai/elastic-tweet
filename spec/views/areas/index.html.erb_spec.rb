require 'rails_helper'

RSpec.describe "areas/index", type: :view do
  before(:each) do
    assign(:areas, [
      Area.create!(
        :latitude => 1.5,
        :longitude => 1.5,
        :radius => 1.5
      ),
      Area.create!(
        :latitude => 1.5,
        :longitude => 1.5,
        :radius => 1.5
      )
    ])
  end

  it "renders a list of areas" do
    render
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
