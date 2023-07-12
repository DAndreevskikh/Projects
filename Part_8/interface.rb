require_relative 'main'

class Interface
  def initialize(main)
    @main = main
  end

  def show_menu
    puts "Enter the number of the action:"
    puts "1. Create a station"
    puts "2. Create a train"
    puts "3. Create a route and manage stations"
    puts "4. Manage stations"
    puts "5. Assign a route to a train"
    puts "6. Attach a wagon to a train"
    puts "7. Detach a wagon from a train"
    puts "8. Move a train forward on the route"
    puts "9. Move a train backward on the route"
    puts "10. Display list of stations and trains on them"
    puts "11. Exit"
    print "Your choice: "
  end

  def manage_stations
    loop do
      puts "Enter the number of the action:"
      puts "1. Add a train to a station"
      puts "2. Remove a train from a station"
      puts "3. Back"
      print "Your choice: "
      action = gets.chomp.to_i

      case action
      when 1
        add_train_to_station
      when 2
        remove_train_from_station
      when 3
        break
      else
        puts "Invalid action. Please try again."
      end
    end
  end

  def add_train_to_station
    if @main.trains.empty?
      puts "No trains available. Please create a train first."
      return
    end

    if @main.stations.empty?
      puts "No stations available. Please create a station first."
      return
    end

    puts "Available stations:"
    @main.stations.each_with_index do |station, index|
      puts "#{index + 1}. #{station.name}"
    end

    print "Enter the index of the station: "
    station_index = gets.chomp.to_i - 1

    station = @main.stations[station_index]
    puts "Available trains:"
    @main.trains.each do |train|
      puts "Train: #{train.number}, Type: #{train.type}"
    end

    print "Enter the number of the train: "
    train_number = gets.chomp

    train = @main.trains.find { |t| t.number == train_number }
    if train.nil?
      puts "Train with number #{train_number} does not exist."
      return
    end

    station.add_train(train)
    puts "Train has been added to the station."
  end

  def remove_train_from_station
    if @main.stations.empty?
      puts "No stations available. Please create a station first."
      return
    end

    puts "Available stations:"
    @main.stations.each_with_index do |station, index|
      puts "#{index + 1}. #{station.name}"
    end

    print "Enter the index of the station: "
    station_index = gets.chomp.to_i - 1

    station = @main.stations[station_index]
    if station.trains.empty?
      puts "No trains at this station."
      return
    end

    puts "Trains at the station:"
    station.each_train do |train|
      puts "Train: #{train.number}, Type: #{train.type}"
    end

    print "Enter the number of the train: "
    train_number = gets.chomp

    train = station.trains.find { |t| t.number == train_number }
    if train.nil?
      puts "Train with number #{train_number} is not at this station."
      return
    end

    station.remove_train(train)
    puts "Train has been removed from the station."
  end

  def display_stations_and_trains
    @main.stations.each do |station|
      puts "Station: #{station.name}"

      station.each_train do |train|
        puts "Train: #{train.number}, Type: #{train.type}, Wagons: #{train.wagons.size}"

        train.each_wagon do |wagon|
          if wagon.is_a?(PassengerWagon)
            puts "  Wagon: #{wagon.number}, Type: #{wagon.type}, Free seats: #{wagon.free_seats}, Occupied seats: #{wagon.occupied_seats}"
          elsif wagon.is_a?(CargoWagon)
            puts "  Wagon: #{wagon.number}, Type: #{wagon.type}, Free volume: #{wagon.free_volume}, Occupied volume: #{wagon.occupied_volume}"
          end
        end
      end

      puts ""
    end
  end

  def manage_wagons
    loop do
      puts "Enter the number of the action:"
      puts "1. Add a wagon to a train"
      puts "2. Remove a wagon from a train"
      puts "3. Occupy seat/volume in a wagon"
      puts "4. Back"
      print "Your choice: "
      action = gets.chomp.to_i

      case action
      when 1
        add_wagon_to_train
      when 2
        remove_wagon_from_train
      when 3
        occupy_seat_or_volume
      when 4
        break
      else
        puts "Invalid action. Please try again."
      end
    end
  end

  def add_wagon_to_train
    if @main.trains.empty?
      puts "No trains available. Please create a train first."
      return
    end

    puts "Available trains:"
    @main.trains.each do |train|
      puts "Train: #{train.number}, Type: #{train.type}"
    end

    print "Enter the number of the train: "
    train_number = gets.chomp

    train = @main.trains.find { |t| t.number == train_number }
    if train.nil?
      puts "Train with number #{train_number} does not exist."
      return
    end

    if train.type == :passenger
      print "Enter the total number of seats in the wagon: "
      total_seats = gets.chomp.to_i
      wagon = PassengerWagon.new(total_seats)
    elsif train.type == :cargo
      print "Enter the total volume of the wagon: "
      total_volume = gets.chomp.to_f
      wagon = CargoWagon.new(total_volume)
    else
      puts "Invalid train type."
      return
    end

    train.attach_wagon(wagon)
    puts "#{wagon.type.capitalize} wagon has been attached to the train."
  end

  def remove_wagon_from_train
    if @main.trains.empty?
      puts "No trains available. Please create a train first."
      return
    end

    puts "Available trains:"
    @main.trains.each do |train|
      puts "Train: #{train.number}, Type: #{train.type}"
    end

    print "Enter the number of the train: "
    train_number = gets.chomp

    train = @main.trains.find { |t| t.number == train_number }
    if train.nil?
      puts "Train with number #{train_number} does not exist."
      return
    end

    if train.wagons.empty?
      puts "No wagons attached to this train."
      return
    end

    puts "Wagons attached to the train:"
    train.each_wagon do |wagon|
      puts "Wagon: #{wagon.number}, Type: #{wagon.type}"
    end

    print "Enter the number of the wagon: "
    wagon_number = gets.chomp

    wagon = train.wagons.find { |w| w.number == wagon_number }
    if wagon.nil?
      puts "Wagon with number #{wagon_number} is not attached to this train."
      return
    end

    train.detach_wagon(wagon)
    puts "#{wagon.type.capitalize} wagon has been detached from the train."
  end

  def occupy_seat_or_volume
    if @main.trains.empty?
      puts "No trains available. Please create a train first."
      return
    end

    puts "Available trains:"
    @main.trains.each do |train|
      puts "Train: #{train.number}, Type: #{train.type}"
    end

    print "Enter the number of the train: "
    train_number = gets.chomp

    train = @main.trains.find { |t| t.number == train_number }
    if train.nil?
      puts "Train with number #{train_number} does not exist."
      return
    end

    if train.wagons.empty?
      puts "No wagons attached to this train."
      return
    end

    puts "Wagons attached to the train:"
    train.each_wagon do |wagon|
      puts "Wagon: #{wagon.number}, Type: #{wagon.type}"
    end

    print "Enter the number of the wagon: "
    wagon_number = gets.chomp

    wagon = train.wagons.find { |w| w.number == wagon_number }
    if wagon.nil?
      puts "Wagon with number #{wagon_number} is not attached to this train."
      return
    end

    if wagon.type == :passenger
      if wagon.free_seats.zero?
        puts "All seats in the wagon are occupied."
        return
      end

      wagon.occupy_seat
      puts "Seat has been occupied in the passenger wagon."
    elsif wagon.type == :cargo
      print "Enter the volume to occupy in the cargo wagon: "
      volume = gets.chomp.to_f

      if volume > wagon.free_volume
        puts "The requested volume exceeds the available space in the wagon."
        return
      end

      wagon.occupy_volume(volume)
      puts "Volume has been occupied in the cargo wagon."
    else
      puts "Invalid wagon type."
    end
  end
end

main = Main.new
interface = Interface.new(main)

loop do
  interface.show_menu
  choice = gets.chomp.to_i

  case choice
  when 1
    main.create_station
  when 2
    main.create_train
  when 3
    main.create_route_and_manage_stations
  when 4
    interface.manage_stations
  when 5
    main.assign_route_to_train
  when 6
    interface.manage_wagons
  when 7
    main.move_train_forward
  when 8
    main.move_train_backward
  when 9
    interface.display_stations_and_trains
  when 10
    interface.display_stations_and_trains
  when 11
    break
  else
    puts "Invalid choice. Please try again."
  end

  puts ""
end
