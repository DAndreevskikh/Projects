# frozen_string_literal: true

require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'train'

# Создаем пассажирский вагон
puts "\nCreating a new passenger wagon..."
passenger_wagon = PassengerWagon.new(30)

puts passenger_wagon.details

# Выводим информацию о пассажирском вагоне
puts "Passenger Wagon Type: #{passenger_wagon.type}"
puts "Passenger Wagon Total Seats: #{passenger_wagon.total_seats}"
puts "Passenger Wagon Occupied Seats: #{passenger_wagon.occupied_seats}"
puts "Passenger Wagon Free Seats: #{passenger_wagon.free_seats}"

# Занимаем места в пассажирском вагоне
puts "\nOccupying seats in the passenger wagon..."
passenger_wagon.take_seat

# Выводим обновленную информацию о пассажирском вагоне
puts "Passenger Wagon Occupied Seats after occupation: #{passenger_wagon.occupied_seats}"
puts "Passenger Wagon Free Seats after occupation: #{passenger_wagon.free_seats}"

# Создаем грузовой вагон
puts "\nCreating a new cargo wagon..."
cargo_wagon = CargoWagon.new(456)

puts cargo_wagon.details

# Выводим информацию о грузовом вагоне
puts "Cargo Wagon Type: #{cargo_wagon.type}"
puts "Cargo Wagon Total Volume: #{cargo_wagon.total_volume}"
puts "Cargo Wagon Occupied Volume: #{cargo_wagon.occupied_volume}"
puts "Cargo Wagon Free Volume: #{cargo_wagon.free_volume}"

# Занимаем объем в грузовом вагоне
puts "\nOccupying volume in the cargo wagon..."
cargo_wagon.take_volume(200)

# Выводим обновленную информацию о грузовом вагоне
puts "Cargo Wagon Occupied Volume after occupation: #{cargo_wagon.occupied_volume}"
puts "Cargo Wagon Free Volume after occupation: #{cargo_wagon.free_volume}"
