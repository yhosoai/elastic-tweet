require 'rails_helper'

RSpec.describe "areas/new", type: :view do
  before(:each) do
    assign(:area, Area.new(
      :latitude => 1.5,
      :longitude => 1.5,
      :radius => 1.5
    ))
  end

  it "renders new area form" do
    render

    assert_select "form[action=?][method=?]", areas_path, "post" do

      assert_select "input#area_latitude[name=?]", "area[latitude]"

      assert_select "input#area_longitude[name=?]", "area[longitude]"

      assert_select "input#area_radius[name=?]", "area[radius]"
    end
  end
end
