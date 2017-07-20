#!/usr/bin/ruby -w

require_relative 'transit_helper'

begin

  @available_routes = TransitHelper.get_available_routes

  if @available_routes.empty?
    puts 'There are no available routes at this time'
    abort
  end

  print 'Enter your route: '
  route_input = gets.chomp

  @route = TransitHelper.find_matching_route(@available_routes, route_input)

  @available_directions = TransitHelper.get_available_directions(@route)

  print "Enter your direction (#{@available_directions.join(",")}): "
  @direction = gets.chomp.strip
  unless @available_directions.include? @direction.downcase
    puts 'Given direction not available for this route'
    abort
  end

  @available_stops = TransitHelper.get_available_stops(@route, @direction)

  print "Enter your stop: "
  stop_input = gets.chomp

  @stop = TransitHelper.find_matching_stop(@available_stops, stop_input)

  @departures = TransitHelper.get_departure_times(@route, @direction, @stop)

  next_departure = TransitHelper.get_next_departure_time(@departures)

  if next_departure.nil?
  	puts 'There are no more departures for this route today'
  else
  	puts "The next departure time is in #{next_departure}"
  end

rescue TransitException => error
  puts error.message
  abort
end









