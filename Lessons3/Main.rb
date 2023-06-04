require_relative 'Train'
require_relative 'Wagon'
require_relative 'Route'
require_relative 'Station'
require_relative 'PassengerTrain'
require_relative 'CargoTrain'
require_relative 'PassengerWagon'
require_relative 'CargoWagon'

class Main
  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def create_station
    puts 'Enter the name of the station:'
    name = gets.chomp
    station = Station.new(name)
    @stations << station
    puts "Station '#{name}' has been created."
  end

  def create_train
    puts 'Enter the train number:'
    number = gets.chomp
    puts 'Enter the train type (passenger or cargo):'
    type = gets.chomp.to_sym
    train = if type == :passenger
              PassengerTrain.new(number)
            elsif type == :cargo
              CargoTrain.new(number)
            else
              puts 'Invalid train type.'
            end
    @trains << train if train
    puts "Train '#{number}' of type '#{type}' has been created."
  end

  def create_route
    puts 'Enter the starting station:'
    starting_station = gets.chomp
    puts 'Enter the ending station:'
    end_station = gets.chomp
    route = Route.new(starting_station, end_station)
    @routes << route
    puts 'Route has been created.'
  end

  def manage_route(route)
    puts 'Enter the number of the action:'
    puts '1. Add a station'
    puts '2. Delete a station'
    action = gets.chomp.to_i
    case action
    when 1
      puts 'Enter the name of the station to add:'
      station = gets.chomp
      route.add_station(station)
      puts "Station '#{station}' has been added to the route."
    when 2
      puts 'Enter the name of the station to delete:'
      station = gets.chomp
      route.delete_station(station)
      puts "Station '#{station}' has been deleted from the route."
    else
      puts 'Invalid action.'
    end
  end

  def assign_route(train, route)
    train.set_route(route)
    puts 'Route has been assigned to the train.'
  end

  def attach_wagon(train)
    wagon = if train.type == :passenger
              PassengerWagon.new
            elsif train.type == :cargo
              CargoWagon.new
            else
              puts 'Invalid train type.'
            end
    train.attach_wagon(wagon) if wagon
    puts 'Wagon has been attached to the train.'
  end

  def detach_wagon(train)
    wagon = train.detach_wagon
    puts 'Wagon has been detached from the train.' if wagon
  end

  def move_forward(train)
    train.move_forward
    puts 'Train has moved forward on the route.'
  end

  def move_backward(train)
    train.move_backward
    puts 'Train has moved backward on the route.'
  end

  def display_stations
    @stations.each do |station|
      puts "Station: #{station.name}"
      puts 'Trains at the station:'
      station.trains.each do |train|
        puts "Train: #{train.number}, Type: #{train.type}"
      end
    end
  end

  def display_trains_on_station(station)
    puts "Station: #{station.name}"
    puts 'Trains at the station:'
    station.trains.each do |train|
      puts "Train: #{train.number}, Type: #{train.type}"
    end
  end

  def start
    loop do
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
      print "You are the choice:  "
      action = gets.chomp.to_i

      if (1..10).include?(action)
      case action
      when 1
        create_station
      when 2
        create_train
      when 3
        create_route
      when 4
        puts 'Enter the train number:'
        train_number = gets.chomp
        train = @trains.find { |t| t.number == train_number }
        puts 'Enter the route number:'
        route_number = gets.chomp
        route = @routes.find { |r| r.number == route_number }
        assign_route(train, route) if train && route
      when 5
        puts 'Enter the train number:'
        train_number = gets.chomp
        train = @trains.find { |t| t.number == train_number }
        attach_wagon(train) if train
      when 6
        puts 'Enter the train number:'
        train_number = gets.chomp
        train = @trains.find { |t| t.number == train_number }
        detach_wagon(train) if train
      when 7
        puts 'Enter the train number:'
        train_number = gets.chomp
        train = @trains.find { |t| t.number == train_number }
        move_forward(train) if train
      when 8
        puts 'Enter the train number:'
        train_number = gets.chomp
        train = @trains.find { |t| t.number == train_number }
        move_backward(train) if train
      when 9
        display_stations
      when 10
        break
      else
        puts 'Invalid action.'
      end
      else
    puts "Invalid choice. Please enter a number from 1 to 10."
   end
  end
 end
end

main = Main.new
main.start
