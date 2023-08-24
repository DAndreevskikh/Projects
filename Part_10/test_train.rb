# frozen_string_literal: true

require_relative 'station'
require_relative 'train'
require_relative 'route'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

# Создаем станции
station1 = Station.new('Station 1')
station2 = Station.new('Station 2')
Station.new('Station 3')

# Проверка создания станций
puts "Stations created: #{Station.all.map(&:name).join(', ')}"
puts "Total number of stations: #{Station.all.size}"

# Создаем поезд
train = Train.new('123', :passenger)

# Выводим информацию о поезде
puts "Train Number: #{train.number}"
puts "Train Type: #{train.type}"
puts "Train Wagons: #{train.wagons.size}"
puts "Train Speed: #{train.speed}"

# Проверка увеличения скорости поезда
train.speed_up(50)
puts "Train Speed after speeding up: #{train.speed}"

# Проверка торможения поезда
train.brake(30)
puts "Train Speed after braking: #{train.speed}"

# Создаем вагоны и присоединяем их к поезду
wagon1 = PassengerWagon.new(30)
wagon2 = CargoWagon.new(500)

# Проверяем тип вагона и присоединяем к поезду
[train, wagon1, wagon2].each do |wagon|
  if wagon.type == train.type
    train.attach_wagon(wagon)
  else
    puts 'Wagon type does not match train type.'
  end
end

# Проверка количества вагонов у поезда
puts "Train wagons after attaching: #{train.wagons.size}"

# Отсоединяем вагон от поезда
train.detach_wagon

# Проверка количества вагонов у поезда после отсоединения
puts "Train wagons after detaching: #{train.wagons.size}"

# Устанавливаем маршрут для поезда
route = Route.new(station1, station2)
train.route = route

# Выводим информацию о текущей, следующей и предыдущей станциях
puts "Current Station: #{train.current_station.name}"
puts "Next Station: #{train.next_station&.name}"
puts "Previous Station: #{train.previous_station&.name}"

# Перемещаем поезд вперед и выводим текущую станцию
train.move_forward
puts "Current Station after moving forward: #{train.current_station&.name}"

# Перемещаем поезд назад и выводим текущую станцию
train.move_backward
puts "Current Station after moving backward: #{train.current_station&.name}"

# Проверка списка поездов на станциях
puts "\nTrains at each station:"
Station.all.each do |station|
  puts "#{station.name}: #{station.trains.map(&:number).join(', ')}"
end
