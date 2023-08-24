# frozen_string_literal: true

require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'wagon'
require_relative 'train'

class WagonManager
  attr_reader :interface, :trains

  def initialize(interface, trains)
    @interface = interface
    @trains = trains
  end

  def create_wagon
    return puts 'No trains available.' if @trains.empty?

    train = @interface.select_train(nil)
    return puts 'No such train.' if train.nil?

    wagon_type = @interface.get_input('Enter the wagon type (passenger/cargo):').downcase
    wagon = instantiate_wagon(wagon_type)
    return unless wagon&.valid?

    add_wagon_to_selected_train(train, wagon)
  end

  def add_wagon_to_train
    return puts 'No trains available.' if @trains.empty?

    train = @interface.select_train
    return puts 'No such train.' if train.nil?

    puts "Select the wagon type:\n1. Cargo\n2. Passenger"
    wagon_choice = gets.to_i
    wagon_type = wagon_choice == 1 ? 'cargo' : 'passenger'

    wagon = create_and_validate_wagon_for_train(wagon_type, train)

    return unless wagon

    train.add_wagon(wagon)
    display_wagon_added_message(train, wagon)
  end

  def remove_wagon_from_train
    return puts 'No trains available.' if @trains.empty?

    train = @interface.select_train(nil)
    return puts 'No such train.' if train.nil?
    return puts 'Train has no wagons to remove.' if train.wagons.empty?

    wagon = select_wagon_from_train(train)
    return unless wagon

    train.remove_wagon(wagon)
    display_wagon_removed_message(wagon)
  rescue StandardError => e
    puts e.message
  end

  def take_seat_or_volume
    return puts 'No trains available.' if no_trains?

    train = @interface.select_train(nil)
    return puts 'No such train.' if train.nil?
    return puts 'Train has no wagons to occupy.' if no_wagons?(train)

    process_wagon_occupation(train)
  rescue StandardError => e
    puts e.message
  end

  def no_trains?
    @trains.empty?
  end

  def no_wagons?(train)
    train.wagons.empty?
  end

  def display_wagon_added_message(train, wagon)
    puts "Wagon has been added to the train. Train now has #{train.wagons.size} wagons."
    puts wagon.details
  end

  def create_and_validate_wagon_for_train(wagon_type, train)
    wagon = instantiate_wagon(wagon_type)
    if wagon && wagon.type.to_s == train.type.to_s
      wagon
    else
      puts 'Invalid wagon type or wagon type does not match train type.'
      nil
    end
  end

  def instantiate_wagon(wagon_type)
    case wagon_type
    when 'cargo'
      instantiate_cargo_wagon
    when 'passenger'
      instantiate_passenger_wagon
    else
      puts 'Invalid wagon type.'
      nil
    end
  end

  def instantiate_cargo_wagon
    capacity = @interface.get_input('Enter the wagon capacity:').to_f
    CargoWagon.new(capacity)
  end

  def instantiate_passenger_wagon
    seats = @interface.get_input('Enter the number of seats:').to_i
    PassengerWagon.new(seats)
  end

  def add_wagon_to_selected_train(train, wagon)
    if wagon.valid?
      train.add_wagon(wagon)
      puts "Wagon has been added to the train. Train now has #{train.wagons.size} wagons."
      puts wagon.details
    else
      puts "Error: #{wagon.errors}"
    end
  end
end

def select_wagon_from_train(train)
  puts "Available wagons for train #{train.number}:"
  train.wagons.each_with_index do |wagon, index|
    puts "#{index + 1}. Wagon: #{wagon.number}, Type: #{wagon.type}"
  end

  wagon_number = input_item_number('Enter the number of the wagon: ', train.wagons)
  wagon = train.wagons[wagon_number - 1]
  return wagon if wagon

  puts 'Invalid wagon number.'
  nil
end

def display_wagon_removed_message(wagon)
  puts 'Wagon has been removed.'
  puts wagon.details
end

def process_wagon_occupation(train)
  wagon = select_wagon_from_train(train)
  return unless wagon

  if wagon.is_a?(CargoWagon)
    occupy_cargo_space(wagon)
  else
    occupy_passenger_seat(wagon)
  end
  puts 'Occupation completed.'
end

def occupy_cargo_space(wagon)
  volume = @interface.get_input('Enter the volume to occupy:')
  wagon.load_cargo(volume.to_f)
end

def occupy_passenger_seat(wagon)
  wagon.take_seat
end
