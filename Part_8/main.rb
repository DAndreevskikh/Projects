require_relative 'train'
require_relative 'wagon'
require_relative 'route'
require_relative 'station'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validation'
require_relative 'interface'

class Main
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
    @interface = Interface.new(self)
  end

  def start
    loop do
      @interface.show_menu
      action = gets.chomp.to_i
      take_action(action)
    end
  end

  def create_train
    begin
      puts 'Enter the train number:'
      number = gets.chomp
      puts 'Enter the train type (passenger/cargo):'
      type = gets.chomp

      train = Train.new(number, type)
      @trains << train

      puts "Train created: Number - #{train.number}, Type - #{train.type}"
    rescue => e
      puts e
    end
  end

  def create_station
    begin
      puts 'Enter the station name:'
      name = gets.chomp

      station = Station.new(name)
      @stations << station

      puts "Station created: #{station.name}"
    rescue => e
      puts e
    end
  end

  def create_route
    begin
      puts 'Enter the start station name:'
      start_station_name = gets.chomp
      puts 'Enter the end station name:'
      end_station_name = gets.chomp

      start_station = find_or_create_station(start_station_name)
      end_station = find_or_create_station(end_station_name)

      route = Route.new(start_station, end_station)
      @routes << route

      puts "Route created: Start station - #{route.stations.first.name}, End station - #{route.stations.last.name}"
    rescue => e
      puts e
    end
  end

  def create_wagon
    begin
      puts 'Enter the wagon type (passenger/cargo):'
      type = gets.chomp

      wagon = Wagon.new(type)
      @wagons << wagon

      puts "Wagon created: Type - #{wagon.type}"
    rescue => e
      puts e
    end
  end

  def occupy_seat(wagon_number)
    wagon = find_wagon_by_number(wagon_number)
    return unless wagon

    if wagon.is_a?(PassengerWagon)
      wagon.occupy_seat
      puts "A seat has been occupied in wagon #{wagon.number}."
    else
      puts "This wagon is not a passenger wagon."
    end
  end

  def occupy_volume(wagon_number, volume)
    wagon = find_wagon_by_number(wagon_number)
    return unless wagon

    if wagon.is_a?(CargoWagon)
      wagon.occupy_volume(volume)
      puts "#{volume} units of volume have been occupied in wagon #{wagon.number}."
    else
      puts "This wagon is not a cargo wagon."
    end
  end

  def display_stations_and_trains
    @stations.each do |station|
      puts "Station: #{station.name}"
      station.each_train do |train|
        puts "Train: #{train.number}, Type: #{train.type}, Wagons: #{train.wagons.size}"
        train.each_wagon do |wagon|
          if wagon.type == :passenger
            puts "  Wagon: #{wagon.number}, Type: #{wagon.type}, Free seats: #{wagon.free_seats}, Occupied seats: #{wagon.occupied_seats}"
          elsif wagon.type == :cargo
            puts "  Wagon: #{wagon.number}, Type: #{wagon.type}, Free volume: #{wagon.free_volume}, Occupied volume: #{wagon.occupied_volume}"
          end
        end
      end
      puts ""
    end
  end

  private

  def find_or_create_station(name)
    station = @stations.find { |s| s.name == name }
    return station if station

    station = Station.new(name)
    @stations << station
    station
  end

  def find_wagon_by_number(number)
    @wagons.find { |wagon| wagon.number == number }
  end

  def take_action(action)
    case action
    when 1
      create_station
    when 2
      create_train
    when 3
      create_route
    when 4
      @interface.manage_stations
    when 5
      assign_route_to_train
    when 6
      attach_wagon_to_train
    when 7
      detach_wagon_from_train
    when 8
      move_train_forward
    when 9
      move_train_backward
    when 10
      display_stations_and_trains
    when 11
      exit
    else
      puts "Invalid action. Please try again."
    end
  end

  def assign_route_to_train
    if @trains.empty?
      puts "No trains available. Please create a train first."
      return
    end

    if @routes.empty?
      puts "No routes available. Please create a route first."
      return
    end

    puts "Available trains:"
    @trains.each do |train|
      puts "Train: #{train.number}, Type: #{train.type}"
    end

    print "Enter the number of the train: "
    train_number = gets.chomp

    train = @trains.find { |t| t.number == train_number }
    if train.nil?
      puts "Train with number #{train_number} does not exist."
      return
    end

    puts "Available routes:"
    @routes.each_with_index do |route, index|
      puts "#{index + 1}. #{route.stations.first.name} - #{route.stations.last.name}"
    end

    print "Enter the index of the route: "
    route_index = gets.chomp.to_i - 1

    route = @routes[route_index]
    train.set_route(route)

    puts "Route has been assigned to the train."
  end

  def attach_wagon_to_train
    train = select_train

    if train
      if train.type == :passenger
        wagon = create_passenger_wagon
      elsif train.type == :cargo
        wagon = create_cargo_wagon
      end

      if wagon
        train.attach_wagon(wagon)
        puts "#{wagon.type.capitalize} wagon has been attached to the train."
      else
        puts "Invalid wagon type."
      end
    end
  end

  def detach_wagon_from_train
    train = select_train

    if train
      train.detach_wagon
      puts "Wagon has been detached from the train."
    end
  end

  def move_train_forward
    train = select_train

    if train
      if train.next_station
        train.move_forward
        puts "Train has been moved forward."
      else
        puts "Train is already at the last station on the route."
      end
    end
  end

  def move_train_backward
    train = select_train

    if train
      if train.previous_station
        train.move_backward
        puts "Train has been moved backward."
      else
        puts "Train is already at the first station on the route."
      end
    end
  end

  def find_station_by_name(name)
    @stations.find { |station| station.name == name }
  end

  def select_train
    print "Enter the number of the train: "
    train_number = gets.chomp
    train = @trains.find { |train| train.number == train_number }

    unless train
      puts "Train not found."
      return nil
    end

    train
  end

  def create_passenger_wagon
    print "Enter the total number of seats in the wagon: "
    total_seats = gets.chomp.to_i
    PassengerWagon.new(total_seats)
  end

  def create_cargo_wagon
    print "Enter the total volume of the wagon: "
    total_volume = gets.chomp.to_f
    CargoWagon.new(total_volume)
  end
end
