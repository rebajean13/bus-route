class TransitHelper
  HOST = 'http://svc.metrotransit.org/NexTrip'
  DIRECTIONS_MAP = {'south' => 1, 'east' => 2, 'west' => 3, 'north' => 4 }

  def self.get_available_routes
    response = self.get_request(HOST, '/Routes')
    JSON.parse(response.body)
  end

  def self.find_matching_route(available_routes, route_description)
    matching_routes = []
    available_routes.each do |route|
      if route['Description'].include? route_description
        matching_routes.push(route)
      end
    end
    if matching_routes.size == 0
      raise TransitException.new("No available route found matching description: #{route_description}")
    elsif matching_routes.size > 1
      raise TransitException.new('More than one route matches your description, please try again with a more specific search.')
    else
      route = matching_routes[0]
    end
    route
  end

  # This method is a shameless copy of the code in the find_matching_route method
  # I ran out of time to refactor the shared logic out into a separate method. -1 point for lack of DRYness
  def self.find_matching_stop(available_stops, stop_description)
    matching_stops = []
    available_stops.each do |stop|
      if stop['Text'].downcase.include? stop_description.downcase
        matching_stops.push(stop)
      end
    end
    if matching_stops.size == 0
      raise TransitException.new("No available stop found matching description: #{stop_description}")
    elsif matching_stops.size > 1
      raise TransitException.new('More than one stop matches your description, please try again with a more specific search.')
    else
      stop = matching_stops[0]
    end
    stop
  end

  def self.get_available_directions(route)
    response = self.get_request(HOST, "/Directions/#{route['Route']}")
    directions = JSON.parse(response.body)
    available_directions = []
    directions.each do |direction|
      available_directions.push(DIRECTIONS_MAP.key(direction['Value'].to_i))
    end
    available_directions
  end

  def self.get_available_stops(route, direction)
    response = get_request(HOST, "/Stops/#{route['Route']}/#{DIRECTIONS_MAP[direction]}")
    JSON.parse(response.body)
  end

  def self.get_departure_times(route, direction, stop)
    response = get_request(HOST, "/#{route['Route']}/#{DIRECTIONS_MAP[direction]}/#{stop['Value']}")
    JSON.parse(response.body)
  end

  def self.get_next_departure_time(departures)
    unless departures.empty?
      next_time = departures[0]['DepartureText']
      unless next_time.downcase.include? 'min'
        ##
        # Known Bug: This doesn't really work if the current time is after 12pm
        # metrotransit's api returns their timestamps on a 12-hr clock and Time.now returns a 24 hour clock. 
        # I didn't have enough time to fix it file it as a known-issue ;) 
        ##
        time_of_departure = Time.parse(next_time)
        num_seconds = time_of_departure - Time.now
        time_in_min = (num_seconds / 60).round
        next_time = "#{time_in_min} Min"
      end
      next_time
    end
  end

  def self.get_request(host, path)
    url = URI.parse(host + path)
    http = Net::HTTP.new(url.host)
    request = Net::HTTP::Get.new(url, 'Accept' => 'application/json')
    begin
      res = http.request(request)
      if res.code != '200'
        raise 'StatusCode =  ' + res.code + '; Error Message = ' + res.message
      end
    rescue SocketError, StandardError => error
      raise TransitException.new("An error occured while sending the request: #{error}")
    end
    res
  end

end

class TransitException < StandardError
  attr_reader :message
  def initialize(message)
    @message = message
  end
end