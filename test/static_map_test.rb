 require 'test_helper'
require 'ostruct'


class StaticMapTest < ActiveSupport::TestCase

  def setup_default_addresses
    @address1 = Struct.new(:lat, :lng, :to_s).new(10.0, 10.0, "Some address")
    @address2 = Struct.new(:lat, :lng, :to_s).new(12.0, 12.0, "Some address 2")
    @addresses = [@address1, @address2]
  end

  setup :setup_default_addresses

  test ".for_address inserts a default zoom of 15" do
      url = BHM::GoogleMaps::StaticMap.for_address(@address1)
      assert_match /zoom=15/, url
  end   

  # Google maps provides a zoom that fits all markers, provided you don't supply a zoom
  test ".for_addresses does not include zoom in the url" do
    url = BHM::GoogleMaps::StaticMap.for_addresses(@addresses)
    assert_no_match /zoom/, url
  end

end
