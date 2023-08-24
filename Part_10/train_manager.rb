# frozen_string_literal: true

require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon_manager'

class TrainManager
  def initialize(interface, trains, routes)
    @interface = interface
    @trains = trains
    @routes = routes
  end

  def create_train
    display_existing_trains
    return unless user_wants_to_create_train?

    train_number = prompt_for_train_number
    train_type = prompt_for_train_type

    actual_train_number = add_train_to_list(train_number, train_type)

    if actual_train_number
      puts "Train #{actual_train_number} created."
    else
      puts "Failed to create train with number #{train_number} and type #{train_type}."
    end
  end

  def prompt_for_train_number
    loop do
      number = @interface.get_input('Enter the train number:')
      return number unless number.strip.empty?

      puts "Train number can't be empty. Please enter a valid train number."
    end
  end

  def train_exists?(number, type = nil)
    if type
      @trains.any? { |train| train.number == number && train.type == type.to_sym }
    else
      @trains.any? { |train| train.number == number }
    end
  end

  def find_next_suffix_for_train(number)
    existing_suffixes = @trains.select { |train| train.number.start_with?(number) }
                               .map { |train| train.number.scan(/\(p(\d+)\)/).flatten.first&.to_i }.compact
    return 2 if existing_suffixes.empty?

    existing_suffixes.max + 1
  end

  def find_train_by_number(train_number, trains_list = @trains)
    trains_list.find { |train| train.number == train_number }
  end

  def delete_train
    return puts 'No trains available.' if @trains.empty?

    display_items('Available trains:', @trains)
    train_number = @interface.get_input('Enter the number of the train to delete:')
    train = find_train_by_number(train_number)
    process_train_deletion(train, train_number)
  end

  def assign_route_to_train
    return puts 'No trains available.' if @trains.empty? || @routes.empty?

    train = @interface.select_train
    return puts 'No such train.' if train.nil?

    route = @interface.select_route
    return puts 'No such route.' if route.nil?

    train.route = route
    puts "Route has been assigned to the train. Train is now on #{train.current_station&.name} station."
  end

  def move_train_forward
    train = @interface.select_train
    return puts 'No such train.' if train.nil?

    return puts 'No route assigned to the train. Please assign a route first.' unless train.route

    display_train_station_info(train)

    return puts 'Train is at the end station.' unless train.next_station

    train.move_forward
    puts "Train has moved forward to the #{train.current_station.name} station."
  end

  def move_train_backward
    train = @interface.select_train
    return puts 'No such train.' if train.nil?

    return puts 'No route assigned to the train. Please assign a route first.' unless train.route

    display_train_station_info(train)

    return puts 'Train is at the start station.' unless train.previous_station

    train.move_backward
    puts "Train has moved backward to the #{train.current_station.name} station."
  end

  def display_train_station_info(train)
    puts "Current station: #{train.current_station&.name || 'N/A'}"
    puts "Next station: #{train.next_station&.name || 'N/A'}"
    puts "Previous station: #{train.previous_station&.name || 'N/A'}"
    puts '-----'
  end

  private

  def display_existing_trains
    return puts 'Trains have not been created before.' unless @trains.any?

    puts 'Previously created trains:'
    @trains.each_with_index do |train, index|
      puts "#{index + 1}. #{train.number} - #{train.type}"
    end
  end

  def user_wants_to_create_train?
    answer = @interface.get_input('Do you want to create a new train? (Y/N): ').downcase
    answer == 'y'
  end

  def prompt_for_train_type
    handle_choice('Choose the train type:', %w[Passenger Cargo]) do |choice|
      return 'passenger' if choice == '1'
      return 'cargo' if choice == '2'

      puts 'Invalid choice. Please select 1 or 2.'
    end
  end

  def handle_choice(prompt, choices)
    loop do
      puts prompt
      choices.each_with_index { |choice, index| puts "#{index + 1}. #{choice}" }
      yield @interface.get_input('Enter your choice:')
    end
  end

  def generate_unique_train_number(number, type)
    suffix = find_next_suffix_for_train(number)
    new_train_number = "#{number} (p#{suffix})"
    puts "Trying number: #{new_train_number}" # Debug print

    while train_exists?(new_train_number, type)
      suffix += 1
      new_train_number = "#{number} (p#{suffix})"
      puts "Trying number: #{new_train_number}" # Debug print
    end

    new_train_number
  end

  def add_train_to_list(number, type)
    if train_exists?(number, type)
      puts "Train with number #{number} and type #{type} already exists. " \
           'Please create a train with a different name and type.'
      return nil
    end

    train = type == 'passenger' ? PassengerTrain.new(number) : CargoTrain.new(number)
    @trains << train
    number
  end
end
