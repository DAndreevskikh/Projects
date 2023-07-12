require_relative 'station'
require_relative 'route'

# Testing Route class
puts "Creating an instance of Route"
station1 = Station.new("Station 1")
station2 = Station.new("Station 2")
station3 = Station.new("Station 3")

route = Route.new(station1, station2)

puts "Start Station: #{route.start_station.name}"
puts "End Station: #{route.end_station.name}"
puts "Stations in the Route: #{route.stations.map(&:name).join(', ')}"

route.delete_station(station2)
puts "Stations in the Route after deleting a station: #{route.stations.map(&:name).join(', ')}"
