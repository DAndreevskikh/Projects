# frozen_string_literal: true

require_relative 'station'
require_relative 'train'
require_relative 'route'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

# Helper method to display information about trains at each station
def display_trains_at_stations(stations)
  puts "\nTrains at each station:"
  stations.each do |station|
    puts "#{station.name}: #{station.trains.map(&:number).join(', ')}"
  end
end

# Helper method to display route details
def display_route_details(route)
  puts "\nRoute details:"
  puts "Start Station: #{route.start_station.name}"
  puts "End Station: #{route.end_station.name}"
  puts 'Stations in Route:'
  route.stations.each do |station|
    puts "Station Name: #{station.name}"
  end
end

# Создаем станции
station1 = Station.new('Station 1')
station2 = Station.new('Station 2')
station3 = Station.new('Station 3')

# Создаем маршрут
puts "\nCreating a new route..."
route = Route.new(station1, station2)
display_route_details(route)

# Добавляем станции в маршрут
puts "\nAdding station3 to the route..."
route.add_station(station3)
display_route_details(route)

# Пытаемся добавить станцию, которая уже есть в маршруте
puts "\nTrying to add station2 again to the route (already present)..."
route.add_station(station2)
display_route_details(route)

# Пытаемся добавить станцию, которая является начальной или конечной
puts "\nTrying to add start station as an intermediate station to the route..."
route.add_station(station1)
display_route_details(route)

# Удаляем станцию из маршрута
puts "\nRemoving station3 from the route..."
route.remove_station(station3)
display_route_details(route)

# Пытаемся удалить станцию, которая является начальной или конечной
puts "\nTrying to remove start station from the route (should not be removed)..."
route.remove_station(station1)
display_route_details(route)

# Удаляем станцию, которая является конечной
puts "\nRemoving end station from the route..."
route.remove_station(station2)
display_route_details(route)

# Устанавливаем новые начальную и конечную станции для маршрута
puts "\nSetting new start and end stations for the route..."
route.start_station = station2
route.end_station = station3
display_route_details(route)

# Создаем поезд и устанавливаем маршрут для него
puts "\nCreating a new train and setting the route..."
train = Train.new('123', :passenger)
train.route = route

# Выводим информацию о текущей, следующей и предыдущей станциях для поезда
puts "\nTrain details:"
puts "Train Number: #{train.number}"
puts "Train Type: #{train.type}"
puts "Current Station: #{train.current_station.name}"
puts "Next Station: #{train.next_station&.name}"
puts "Previous Station: #{train.previous_station&.name}"

# Перемещаем поезд вперед и выводим текущую станцию
puts "\nMoving the train forward..."
train.move_forward
puts "Current Station after moving forward: #{train.current_station&.name}"

# Перемещаем поезд назад и выводим текущую станцию
puts "\nMoving the train backward..."
train.move_backward
puts "Current Station after moving backward: #{train.current_station&.name}"

# Создаем еще несколько станций и добавляем их в маршрут
puts "\nCreating more stations and adding them to the route..."
station4 = Station.new('Station 4')
station5 = Station.new('Station 5')
station6 = Station.new('Station 6')
route.add_station(station4)
route.add_station(station5)
route.add_station(station6)
display_route_details(route)

# Проверяем список поездов на каждой станции
display_trains_at_stations([station1, station2, station3, station4, station5, station6])

# Устанавливаем маршрут для другого поезда и перемещаем его
puts "\nCreating another train and setting the route..."
train2 = Train.new('456', :cargo)
train2.route = route
train2.move_forward
puts "Current Station of train2 after moving forward: #{train2.current_station&.name}"

# Проверяем список поездов на каждой станции после перемещения train2
display_trains_at_stations([station1, station2, station3, station4, station5, station6])

# Отображаем детали каждого поезда
puts "\nDetails of each train:"
puts train.details
puts train2.details
