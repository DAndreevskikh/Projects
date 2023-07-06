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
require_relative 'interface'

class Main
  def initialize
    @stations = []  # Массив для хранения станций
    @trains = []  # Массив для хранения поездов
    @routes = []  # Массив для хранения маршрутов
  end

  def start
    loop do
      show_menu
      action = gets.chomp.to_i
      take_action(action)
    end
  end

  protected

  # Выводит меню пользователю
  def show_menu
    puts "Enter the number of the action:"
    puts "1. Create a station"
    puts "2. Create a train"
    puts "3. Create a route and manage stations"
    puts "4. Assign a route to a train"
    puts "5. Attach a wagon to a train"
    puts "6. Detach a wagon from a train"
    puts "7. Move a train forward on the route"
    puts "8. Move a train backward on the route"
    puts "9. Display list of stations and trains on them"
    puts "10. Exit"
    print "Your choice: "
  end

  # Выполняет действие на основе выбора пользователя
  def take_action(action)
    case action
    when 1
      create_station
    when 2
      create_train
    when 3
      create_route
    when 4
      assign_route_to_train
    when 5
      attach_wagon_to_train
    when 6
      detach_wagon_from_train
    when 7
      move_train_forward
    when 8
      move_train_backward
    when 9
      display_stations_and_trains
    when 10
      exit
    else
      puts "Invalid action. Please try again."
    end
  end

  # Создает новую станцию и добавляет ее в массив станций
  def create_station
    puts "Enter the name of the station: "
    name = gets.chomp
    station = Station.new(name)
    @stations << station
    puts "Station #{name} has been created."
  end

  # Создает новый поезд и добавляет его в массив поездов
  def create_train
    puts "Enter the number of the train: "
    number = gets.chomp

    if number.match?(/^\d+$/) # Проверка ввода для номера поезда, в отсутствии букв.
      puts "Select the type of the train:"
      puts "1. Passenger"
      puts "2. Cargo"

      type_choice = gets.chomp.to_i
      if [1, 2].include?(type_choice)
        type = (type_choice == 1) ? :passenger : :cargo
        train = Train.new(number, type)
        @trains << train
        puts "Train #{number} of type #{type} has been created."
      else
        puts "Invalid input. Please enter 1 for passenger train or 2 for cargo train."
      end
    else
      puts "Invalid input. The train number should contain only digits."
    end
  end

  # Создает новый маршрут и добавляет его в массив маршрутов
  def create_route
    if @stations.size < 2
      puts "Not enough stations to create a route. Please create at least 2 stations."
      return
    end

    puts "Available stations:"
    @stations.each_with_index do |station, index|
      puts "#{index + 1}. #{station.name}"
    end

    print "Enter the index of the start station: "
    start_index = gets.chomp.to_i - 1

    print "Enter the index of the end station: "
    end_index = gets.chomp.to_i - 1

    start_station = @stations[start_index]
    end_station = @stations[end_index]

    route = Route.new(start_station, end_station)
    @routes << route

    puts "Route from #{start_station.name} to #{end_station.name} has been created."
  end

  # Назначает маршрут поезду
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
      puts "#{index + 1}. #{route.start_station.name} - #{route.end_station.name}"
    end

    print "Enter the index of the route: "
    route_index = gets.chomp.to_i - 1

    route = @routes[route_index]
    train.set_route(route)

    puts "Route has been assigned to the train."
  end

  # Прицепляет вагон к поезду
  def attach_wagon_to_train
    train = select_train

    if train
      print "Enter the type of the wagon (1 for passenger wagon, 2 for cargo wagon): "
      wagon_type = gets.chomp.to_i

      case wagon_type
      when 1
        wagon = PassengerWagon.new
        train.attach_wagon(wagon)
        puts "Passenger wagon has been attached to the train."
      when 2
        wagon = CargoWagon.new
        train.attach_wagon(wagon)
        puts "Cargo wagon has been attached to the train."
      else
        puts "Invalid wagon type."
      end
    end
  end

  # Отсоединяет вагон от поезда
  def detach_wagon_from_train
    train = select_train

    if train
      train.detach_wagon
      puts "Wagon has been detached from the train."
    end
  end

  # Перемещает поезд вперед по маршруту
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

  # Перемещает поезд назад по маршруту
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

  # Выводит список станций и поездов на них
  def display_stations_and_trains
    @stations.each do |station|
      puts "Station: #{station.name}"
      station.trains.each do |train|
        puts "Train: #{train.number}, type: #{train.type}, wagons: #{train.wagons.size}"
      end
      puts ""
    end
  end

  # Находит станцию по имени
  def find_station_by_name(name)
    @stations.find { |station| station.name == name }
  end

  # Выбирает поезд из массива по его номеру
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

  # Выбирает маршрут из массива по его индексу
  def select_route
    print "Enter the index of the route: "
    route_index = gets.chomp.to_i
    route = @routes[route_index]

    unless route
      puts "Route not found."
      return nil
    end

    route
  end

  # Добавляет станцию к маршруту
  def add_station_to_route(route)
    loop do
      print "Enter the name of the station to add to the route (or 'done' to finish): "
      station_name = gets.chomp

      break if station_name.downcase == 'done'

      station = find_station_by_name(station_name)

      if station
        route.add_station(station)
        puts "Station #{station_name} has been added to the route."
      else
        puts "Station not found."
      end
    end
  end
end

main = Main.new
main.start
