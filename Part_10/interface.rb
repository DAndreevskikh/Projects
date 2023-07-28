# frozen_string_literal: true

class Interface
  ACTIONS = {
    1 => :create_station, 2 => :create_train, 3 => :create_route,
    4 => :manage_stations, 5 => :assign_route_to_train,
    6 => :add_wagon_to_train, 7 => :remove_wagon_from_train,
    8 => :move_train_forward, 9 => :move_train_backward,
    10 => :display_stations_and_trains, 11 => :exit
  }.freeze

  def initialize(main)
    @main = main
  end

  def show_menu
    puts 'Enter the number of the action:'
    ACTIONS.each { |num, action| puts "#{num}. #{action.to_s.capitalize}" }
    print 'Your choice: '
  end

  def manage_stations
    loop { break unless process_action_input }
  end

  def add_train_to_station
    return puts 'No trains available.' if @main.trains.empty?
    return puts 'No stations available.' if @main.stations.empty?

    station = select_station
    train = select_train
    return unless station && train

    station.add_train(train)
    puts 'Train has been added to the station.'
  end

  def remove_train_from_station
    return puts 'No stations available.' if @main.stations.empty?

    station = select_station
    return puts 'No trains at this station.' if station.trains.empty?

    train = select_train(station)
    return puts "Train with number #{train.number} is not at this station." if train.nil?

    station.remove_train(train)
    puts 'Train has been removed from the station.'
  end

  private

  def process_action_input
    puts 'Enter the number of the action:'
    print_actions
    print 'Your choice: '
    action = gets.chomp.to_i

    execute_action(action)
  end

  def execute_action(action)
    case action
    when 1..3 then send(ACTIONS[action])
    when 4 then manage_stations
    when 5..9 then send(ACTIONS[action])
    when 10 then display_stations_and_trains
    when 11 then false
    else
      puts 'Invalid action. Please try again.'
      true
    end
  end

  def print_actions
    ACTIONS.each { |num, action| puts "#{num}. #{action.to_s.capitalize}" }
  end

  def display_stations(message)
    puts message
    @main.stations.each.with_index(1) { |station, index| puts "#{index}. #{station.name}" }
  end

  def display_trains(message, trains)
    puts message
    trains.each { |train| puts "Train: #{train.number}, Type: #{train.type}" }
  end

  def input_index(prompt, max_index)
    print prompt
    index = gets.to_i - 1
    index.between?(0, max_index - 1) ? index : input_index(prompt, max_index)
  end

  def input_train_number(prompt, trains)
    print prompt
    train_number = gets.chomp
    trains.any? { |train| train.number == train_number } ? train_number : input_train_number(prompt, trains)
  end

  def find_train_by_number(train_number)
    @main.trains.find { |train| train.number == train_number }
  end

  def select_station
    display_stations('Available stations:')
    @main.stations[input_index('Enter the index of the station: ', @main.stations.size)]
  end

  def select_train(station = nil)
    trains = station ? station.trains : @main.trains
    display_trains('Available trains:', trains)
    train_number = input_train_number('Enter the number of the train: ', trains)
    find_train_by_number(train_number)
  end
end
