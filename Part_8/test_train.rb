require_relative 'train'
require_relative 'wagon'
require_relative 'station'
require_relative 'route'
# Testing Train class
puts "Creating an instance of Train"
train = Train.new("123", :passenger)

puts "Train Number: #{train.number}"
puts "Train Type: #{train.type}"
puts "Train Wagons: #{train.wagons}"
puts "Train Speed: #{train.speed}"

train.speed_up(50)
puts "Train Speed after speeding up: #{train.speed}"

train.break(30)
puts "Train Speed after breaking: #{train.speed}"

wagon1 = Wagon.new(:passenger)
wagon2 = Wagon.new(:cargo)

train.attach_wagon(wagon1)
train.attach_wagon(wagon2)

train.detach_wagon

station1 = Station.new("Station 1")
station2 = Station.new("Station 2")
station3 = Station.new("Station 3")

route = Route.new(station1, station2)
train.set_route(route)

puts "Current Station: #{train.current_station_name}"
puts "Next Station: #{train.next_station&.name}"
puts "Previous Station: #{train.previous_station&.name}"

train.move_forward
puts "Current Station after moving forward: #{train.current_station_name}"

train.move_backward
puts "Current Station after moving backward: #{train.current_station_name}"
