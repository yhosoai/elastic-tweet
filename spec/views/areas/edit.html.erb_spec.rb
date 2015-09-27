require 'rails_helper'

RSpec.describe "areas/edit", type: :view do
  before(:each) do
    @area = assign(:area, Area.create!(
      :latitude => 1.5,
      :longitude => 1.5,
      :radius => 1.5
    ))
  end

  it "renders the edit area form" do
    render

    assert_select "form[action=?][method=?]", area_path(@area), "post" do

      assert_select "input#area_latitude[name=?]", "area[latitude]"

      assert_select "input#area_longitude[name=?]", "area[longitude]"

      assert_select "input#area_radius[name=?]", "area[radius]"
    end
  end
end
