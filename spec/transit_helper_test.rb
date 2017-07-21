require_relative '../transit_helper'
require 'net/http'
require 'Time'

route1 = {"Description"=>"2 - Franklin Av - Riverside Av - U of M - 8th St SE", "ProviderID"=>"8", "Route"=>"2"}
route2 = {"Description"=>"3 - U of M - Como Av - Energy Park Dr - Maryland Av", "ProviderID"=>"8", "Route"=>"3"}
route3 = {"Description"=>"6 - U of M - Hennepin - Xerxes - France - Southdale", "ProviderID"=>"8", "Route"=>"6"}

stop1 = {"Text"=>"Jefferson St and 117th Ave", "Value"=>"117J"}
stop2 = {"Text"=>"Park of the Four Seasons", "Value"=>"4SEA"}
stop3 = {"Text"=>"Northtown Transit Center", "Value"=>"NOTW"}
stop4 = {"Text"=>"Blaine Human Service Center", "Value"=>"BLHS"}

southbound_stops = [stop1, stop2]
northbound_stops = [stop3, stop4]

departure1 = {"Actual"=>false, "BlockNumber"=>1529, "DepartureText"=>"10:31", "DepartureTime"=>"/Date(1500521460000-0500)/", "Description"=>"Ltd Stop /Dtwn St Paul/ Via Airport", "Gate"=>"", "Route"=>"54", "RouteDirection"=>"EASTBOUND", "Terminal"=>"", "VehicleHeading"=>0, "VehicleLatitude"=>44.94347, "VehicleLongitude"=>-93.10408}

departures = [departure1]

south_direction = {"Text" => "SOUTHBOUND", "Value" => "1"}
north_direction = {"Text" => "NORTHBOUND", "Value" => "4"}

directions = [south_direction, north_direction]

fake_available_routes = [route1, route2, route3]

describe TransitHelper do
  context "When one route matches the user input" do
    it "The find_matching_route method should return the route" do
      route_input = "Franklin"
      route = TransitHelper.find_matching_route(fake_available_routes, route_input)
      expect(route).to eq(route1)
    end
  end
end

describe TransitHelper do
  context 'When multiple routes match the user input' do
    it 'The find_matching_route method should raise an exception' do
      route_input = 'U of M'
      expect{ TransitHelper.find_matching_route(fake_available_routes, route_input) } .to raise_error(TransitException)
    end
  end
end

describe TransitHelper do
  context "When no routes match the user input" do
    it "The find_matching_route method should raise an exception" do
      route_input = "Bogus"
      expect{ TransitHelper.find_matching_route(fake_available_routes, route_input) }.to raise_error(TransitException)
    end
  end
end

describe TransitHelper do
  context "When a departure time is given as a timestamp" do
    it "we return how many minutes the timestamp is from the current time" do
      @time_now = Time.new(2017,07,19,10, 5,0, "-05:00")
      allow(Time).to receive(:now).and_return(@time_now)
      next_time = TransitHelper.get_next_departure_time(departures)
      expect(next_time).to eq('26 Min')
    end
  end
end
