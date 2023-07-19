# frozen_string_literal: true

require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'
require_relative 'interface'
require_relative 'instance_counter'

class Main
  include InstanceCounter

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @interface = Interface.new(self)
  end

  def start
    loop do
      @interface.show_menu
      take_action(gets.to_i)
    end
  end

  private

  def take_action(action)
    return puts 'Invalid action. Please try again.' unless Interface::ACTIONS.key?(action)

    send(Interface::ACTIONS[action])
  end

  def create_train
    create_item(Train, @trains, get_input('Enter the train number:'),
                get_input('Enter the train type (passenger/cargo):'))
  end

  def create_station
    create_item(Station, @stations, get_input('Enter the station name:'))
  end

  def create_route
    start_station = find_or_create_station(get_input('Enter the start station name:'))
    end_station = find_or_create_station(get_input('Enter the end station name:'))
    create_item(Route, @routes, start_station, end_station)
  end

  def add_train_to_station
    return puts 'No trains available.' if @trains.empty? || @stations.empty?

    station = select_station
    display_items('Available trains:', @trains)
    train_number = input_item_number('Enter the number of the train: ', @trains)
    train = @trains.find { |t| t.number == train_number }
    return puts "Train with number #{train_number} does not exist." if train.nil?

    station.add_train(train)
    puts 'Train has been added to the station.'
  end

  def remove_train_from_station
    return puts 'No stations available.' if @stations.empty?

    station = select_station
    return puts 'No trains at this station.' if station.trains.empty?

    train = select_train(station)
    return puts "Train with number #{train.number} is not at this station." if train.nil?

    station.remove_train(train)
    puts 'Train has been removed from the station.'
  end

  def display_stations_and_trains
    @stations.each do |station|
      puts "Station: #{station.name}\n#{station.trains.map { |train| display_train_info(train) }.join("\n")}"
    end
  end

  def find_or_create_station(name)
    @stations.find { |s| s.name == name } || create_item(Station, @stations, name)
  end

  def create_item(klass, collection, *args)
    item = klass.new(*args)
    collection << item
    puts "#{klass} created: #{item.details}" if item.valid?
    item
  rescue StandardError => e
    puts e
  end

  def display_items(message, items)
    puts "#{message}\n#{items.map(&:details).join("\n")}"
  end

  def input_index(prompt, max_index)
    print prompt
    index = gets.to_i - 1
    index.between?(0, max_index - 1) ? index : input_index(prompt, max_index)
  end

  def input_item_number(prompt, items)
    print prompt
    item_number = gets.chomp
    items.any? { |item| item.number == item_number } ? item_number : input_item_number(prompt, items)
  end

  def display_train_info(train)
    "Train: #{train.number}, Type: #{train.type}, Wagons: #{train.wagons.size}"
  end

  def get_input(prompt)
    print prompt
    gets.chomp
  end

  def select_station
    display_items('Available stations:', @stations)
    @stations[input_index('Enter the index of the station: ', @stations.size)]
  end

  def select_train(station)
    display_items('Trains at the station:', station.trains)
    train_number = input_item_number('Enter the number of the train: ', station.trains)
    station.trains.find { |t| t.number == train_number }
  end
end

Main.new.start
