# frozen_string_literal: true

class Interface
  ACTIONS = {
    1 => :create_train,
    2 => :create_station,
    3 => :create_route,
    4 => :assign_route_to_train,
    5 => :add_wagon_to_train,
    6 => :remove_wagon_from_train,
    7 => :move_train_forward,
    8 => :move_train_backward,
    9 => :list_stations_and_trains,
    10 => :manage_trains_and_stations
  }.freeze

  MENU_ITEMS = [
    'Create train',
    'Create station',
    'Create route',
    'Assign route to train',
    'Add wagon to train',
    'Remove wagon from train',
    'Move train forward',
    'Move train backward',
    'List stations and trains',
    'Manage trains and stations',
    'Exit'
  ].freeze

  def initialize(main)
    @main = main
  end

  def show_menu
    puts 'Select action:'
    MENU_ITEMS.each_with_index do |item, index|
      puts "#{index + 1}. #{item}"
    end
  end

  def get_input(prompt)
    print prompt
    gets.chomp
  end

  def display_items(header, items, &block)
    puts header
    items.each_with_index(&block)
  end

  def display_trains(header, trains)
    display_items(header, trains) do |train, index|
      puts "#{index + 1}. Train: #{train.number}, Type: #{train.type}"
    end
  end

  def select_station
    select_item('Available stations:', @main.stations) do |station|
      "#{station.name}, Trains: #{station.trains.map(&:number).join(', ')}"
    end
  end

  def select_train(station = nil)
    trains = station ? station.trains : @main.trains
    select_item('Available trains:', trains) do |train|
      "Train: #{train.number}, Type: #{train.type}"
    end
  end

  def select_route
    if @main.routes.empty?
      puts 'No routes available.'
      return nil
    end

    display_items('Available routes:', @main.routes) do |route, index|
      puts "#{index + 1}. Route: #{route.start_station.name} -> #{route.end_station.name}"
    end

    index = get_input('Enter the index of the route: ').to_i - 1
    @main.routes[index]
  end

  def display_stations_and_trains
    display_stations
    display_all_trains
  end

  def display_stations
    if @main.stations.empty?
      puts "\nNo stations available."
      return
    end

    puts "\nStations and Trains:\n"
    @main.stations.each do |station|
      puts "Station: #{station.name}"
      display_trains_on_station(station)
      puts '-----'
    end
  end

  def display_trains_on_station(station)
    if station.trains.empty?
      puts 'No trains at this station.'
      return
    end

    station.trains.each do |train|
      puts "Train: #{train.number}, Type: #{train.type}, Wagons: #{train.wagons.size}"
    end
  end

  def display_all_trains
    if @main.trains.empty?
      puts "\nNo trains available."
      return
    end

    puts "\nAll Trains:\n"
    @main.trains.each do |train|
      puts "Train: #{train.number}, Type: #{train.type}, Wagons: #{train.wagons.size}"
    end
  end

  private

  def select_item(header, items)
    display_items(header, items) do |item, index|
      puts "#{index + 1}. #{yield(item)}"
    end
    index = get_input('Enter the index: ').to_i - 1
    items[index]
  end
end

def manage_trains_and_stations
  loop do
    display_management_menu
    choice = gets.to_i
    break if choice == 5

    process_management_choice(choice)
  end
end

def display_management_menu
  puts 'Manage Trains and Stations:'
  puts '1. Rename Station'
  puts '2. Delete Station'
  puts '3. Add Train to Station'
  puts '4. Remove Train from Station'
  puts '5. Back to main menu'
end

def process_management_choice(choice)
  action = get_action(choice)
  if action
    send(action) if action.is_a? Symbol
  else
    puts 'Invalid choice. Try again.'
  end
end

def get_action(choice)
  actions = {
    1 => :rename_station,
    2 => :delete_station,
    3 => :add_train_to_station,
    4 => :remove_train_from_station,
    5 => nil
  }
  actions[choice]
end
