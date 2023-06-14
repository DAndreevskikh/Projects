require_relative 'station'
require_relative 'train'

# Testing Station class
puts "Creating an instance of Station"
station = Station.new("Station 1")

puts "Station Name: #{station.name}"
puts "Trains at the Station: #{station.trains}"

train1 = Train.new("123", :passenger)
train2 = Train.new("456", :cargo)

station.take_train(train1)
station.take_train(train2)

puts "Trains at the Station after taking trains: #{station.trains}"
puts "Passenger Trains at the Station: #{station.trains_by_type(:passenger)}"
puts "Cargo Trains at the Station: #{station.trains_by_type(:cargo)}"

station.delete_train(train1)
puts "Trains at the Station after deleting a train: #{station.trains}"
