require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'wagon'
require_relative 'train'
require_relative 'station'
require_relative 'route'

include Manufacturer
include InstanceCounter

wagon = Wagon.new("cargo")
wagon.manufacturer = "Example Manufacturer"
puts "Wagon Manufacturer: #{wagon.manufacturer}"

train = Train.new(123, "cargo")
train.manufacturer = "Example Manufacturer"
puts "Train Manufacturer: #{train.manufacturer}"

# Creating additional instances
train1 = Train.new("001", :passenger)
train2 = Train.new("002", :cargo)

station1 = Station.new("Station 1")
station2 = Station.new("Station 2")
station3 = Station.new("Station 3")

route = Route.new(station1, station2)
route.add_station(station3)

# Station class method all
puts "All Stations: #{Station.all}"

# Train Number attribute
train = Train.new("123", :passenger)
puts "Train Number: #{train.number}"

# Train class method find
found_train = Train.find("123")
if found_train
  puts "Found Train: Train Number - #{found_train.number}, Train Type - #{found_train.type}"
else
  puts "Train not found"
end

puts "Train Instances: #{Train.instances}"
puts "Route Instances: #{Route.instances}"
puts "Station Instances: #{Station.instances}"
