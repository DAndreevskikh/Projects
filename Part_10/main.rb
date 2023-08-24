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
require_relative 'accessors'
require_relative 'validation'
require_relative 'train_manager'
require_relative 'wagon_manager'

class Main
  include InstanceCounter
  include Accessors

  EXIT_ACTION = 11

  attr_accessor_with_history :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @interface = Interface.new(self)
    @train_manager = TrainManager.new(@interface, @trains, @routes)
    @wagon_manager = WagonManager.new(@interface, @trains)
    self.class.define_management_methods
  end

  def self.define_management_methods
    %w[create_train move_train_forward move_train_backward assign_route_to_train display_train_station_info
       instantiate_wagon find_train_by_number create_wagon add_wagon_to_selected_train
       remove_wagon_from_selected_train select_wagon_from_train occupy_cargo_space occupy_passenger_seat
       process_wagon_occupation].each do |method_name|
      define_method(method_name) do
        manager = method_name.include?('train') ? @train_manager : @wagon_manager
        manager.send(method_name)
      end
    end
  end

  def start
    loop do
      @interface.show_menu
      action = gets.to_i
      break if action == EXIT_ACTION

      take_action(action)
    end
  end

  def create_station
    display_previously_created_stations

    station_name = prompt_for_station_name
    return if station_exists?(station_name)

    add_new_station(station_name)
  end

  def create_route
    display_previously_created_routes
    start_station, end_station = prompt_for_start_and_end_stations

    if start_station.nil? || end_station.nil?
      puts 'Error: Invalid station names.'
      return
    end

    create_and_store_route(start_station, end_station) unless route_exists?(start_station, end_station)
  end

  private

  def display_previously_created_stations
    if @stations.any?
      puts 'Previously created stations:'
      @stations.each_with_index do |station, index|
        puts "#{index + 1}. #{station.name}"
      end
      answer = @interface.get_input('Do you want to create a new station? (Y/N): ').downcase
      nil unless answer == 'y'
    else
      puts 'Stations have not been created before.'
    end
  end

  def prompt_for_station_name
    @interface.get_input('Enter the station name:')
  end

  def add_new_station(name)
    station = create_item(Station, name)
    @stations << station unless station.nil?
  end

  def take_action(action)
    return puts 'Invalid action. Please try again.' unless Interface::ACTIONS.key?(action)

    send(Interface::ACTIONS[action])
  end

  def display_previously_created_routes
    if @routes.any?
      puts 'Previously created routes:'
      @routes.each_with_index do |route, index|
        puts "#{index + 1}. Route: #{route.start_station.name} -> #{route.end_station.name}"
      end
      answer = @interface.get_input('Do you want to create a new route? (Y/N): ').downcase
      nil unless answer == 'y'
    else
      puts 'Routes have not been created before.'
    end
  end

  def prompt_for_start_and_end_stations
    start_station = find_or_create_station(@interface.get_input('Enter the start station name:'))
    end_station = find_or_create_station(@interface.get_input('Enter the end station name:'))
    [start_station, end_station]
  end

  def create_and_store_route(start_station, end_station)
    route = Route.new(start_station, end_station)
    @routes << route
    puts "Route created: #{route.details}"
  end

  def station_exists?(name)
    @stations.any? { |station| station.name == name }
  end

  def route_exists?(start_station, end_station)
    @routes.any? do |route|
      route.start_station == start_station && route.end_station == end_station
    end
  end

  def handle_missing_stations(start_station, end_station)
    puts 'Error: Failed to find or create stations.' if start_station.nil? || end_station.nil?
  end

  def display_wagon_added_message(_train, _wagon)
    @wagon_manager.display_wagon_added_message
  end

  def rename_station
    return puts 'No stations available.' if @stations.empty?

    station = @interface.select_station
    display_name_history(station) { |name| puts name }
    update_station_name(station)
    display_name_history(station) { |name| puts name }
    puts "Station renamed to #{station.name}."
  end
end

def display_name_history(station, &block)
  previous_names = station.name_history - [station.name]
  if previous_names.any?
    puts 'Previous names for the station:'
    previous_names.each(&block)
  else
    puts 'This station has not been renamed before.'
  end
end

def update_station_name(station)
  new_name = @interface.get_input('Enter the new name for the station:')
  station.name = new_name
end

def delete_station
  return puts 'No stations available.' if @stations.empty?

  station = @interface.select_station
  return puts 'No such station.' if station.nil?

  @stations.delete(station)
  puts "Station #{station.name} deleted."
end

def add_train_to_station
  return puts 'No trains available.' if @trains.empty? || @stations.empty?

  station = @interface.select_station
  return puts 'No such station.' if station.nil?

  train = @interface.select_train
  return puts 'No such train.' if train.nil?

  station.add_train(train)
  puts 'Train has been added to the station.'
end

def add_wagon_to_train
  @wagon_manager.add_wagon_to_train
end

def create_and_validate_wagon_for_train(_wagon_type, _train)
  @wagon_manager.create_and_validate_wagon_for_train
end

def remove_train_from_station
  return puts 'No stations available.' if @stations.empty?

  station = @interface.select_station
  return puts 'No trains at this station.' if station.trains.empty?

  train = @interface.select_train(station)
  return puts "Train with number #{train.number} is not at this station." if train.nil?

  station.remove_train(train)
  puts 'Train has been removed from the station.'
end

def input_item_number(prompt, items)
  loop do
    print prompt
    number = gets.to_i
    return number if (1..items.size).include?(number)

    puts 'Invalid number. Please try again.'
  end
end

def display_wagon_removed_message(_wagon)
  @wagon_manager.display_wagon_removed_message
end

def list_stations_and_trains
  @interface.display_stations_and_trains
end

def display_stations_and_trains
  @interface.display_stations_and_trains
end

def find_or_create_station(name)
  station = @stations.find { |s| s.name == name }
  unless station
    station = create_item(Station, name)
    @stations << station if station
  end
  station
end

def create_item(klass, name)
  item = klass.new(name)
  if item.valid?
    puts "#{klass} created: #{item.details}"
    item
  end
rescue StandardError => e
  puts e
  nil
end

def display_station_info(station)
  "Station: #{station.name}, Trains: #{station.trains.map(&:number).join(', ')}"
end

def process_train_deletion(train, train_number)
  if train
    @trains.delete(train)
    puts "Train #{train.number} deleted."
  else
    puts "No such train with number #{train_number}."
  end
end

Main.new.start
