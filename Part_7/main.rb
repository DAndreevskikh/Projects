require_relative 'train'
require_relative 'wagon'
require_relative 'route'
require_relative 'station'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validation'

  private

  def show_menu
  puts 'Enter the number of the action:'
  puts '1. Create a station'
  puts '2. Create a train'
  puts '3. Create a route and manage stations'
  puts '4. Assign a route to a train'
  puts '5. Attach a wagon to a train'
  puts '6. Detach a wagon from a train'
  puts '7. Move a train forward on the route'
  puts '8. Move a train backward on the route'
  puts '9. Display list of stations and trains on them'
  puts '10. Exit'
  print 'Your choice: '
end

def run
  loop do
    show_menu
    choice = gets.chomp.to_i

    case choice
    when 1
      create_station
    when 2
      create_train
    when 3
      create_route
    when 10
      break
    else
      puts 'Invalid choice. Please try again.'
    end
  end
end

def create_station
  puts 'Enter the station name:'
  name = gets.chomp

  station = Station.new(name)
  puts "Station created: #{station.name}"
rescue RuntimeError => e
  puts "Error: #{e.message}. Please try again."
  create_station
end

def create_train
  puts 'Enter the train number:'
  number = gets.chomp
  puts 'Enter the train type (passenger/cargo):'
  type = gets.chomp

  train = Train.new(number, type)
  puts "Train created: Number - #{train.number}, Type - #{train.type}"
rescue RuntimeError => e
  puts "Error: #{e.message}. Please try again."
  create_train
end

def create_route
  puts 'Enter the start station name:'
  start_station_name = gets.chomp
  puts 'Enter the end station name:'
  end_station_name = gets.chomp

  start_station = Station.new(start_station_name)
  end_station = Station.new(end_station_name)
  route = Route.new(start_station, end_station)
  puts "Route created: Start station - #{route.stations.first.name}, End station - #{route.stations.last.name}"
rescue RuntimeError => e
  puts "Error: #{e.message}. Please try again."
  create_route
end

run
