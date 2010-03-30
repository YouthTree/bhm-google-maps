require 'test_helper'
require 'ostruct'

class HelperTest < ActionView::TestCase
  
  def setup_default_address
    @address = Struct.new(:lat, :lng, :to_s).new(10.0, 10.0, "Some address")
  end
  
  setup :setup_default_address
  
  test "should return false if not using google maps js" do
    assert !using_gmaps_js?
  end
  
  test "should let you use google maps js" do
    use_gmaps_js
    assert using_gmaps_js?
    assert_select 'script'
  end
  
  test "should let you draw a map of an address" do
    concat draw_map_of(@address)
    assert_select '.gmap'
  end
  
  test "should automatically use gmap js when an address is drawn" do
    assert !using_gmaps_js?
    concat draw_map_of(@address)
    assert using_gmaps_js?
  end
  
  test "should correctly add a container with an address" do
    concat draw_map_of(@address)
    assert_select ".#{BHM::GoogleMaps.container_class}"
  end
  
  test "should correctly add an image with an address" do
    concat draw_map_of(@address)
    assert_select ".#{BHM::GoogleMaps.static_map_class}"
  end
  
  test "should append a static map image" do
    concat draw_map_of(@address)
    assert_select ".#{BHM::GoogleMaps.static_map_class} img"
  end
  
end