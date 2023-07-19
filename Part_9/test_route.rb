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
station3 = Station.new('Station 3')

# Создаем маршрут
route = Route.new(station1, station2)

# Добавляем станции в маршрут
route.add_station(station3)

# Выводим информацию о станциях в маршруте
puts 'Stations in Route:'
route.stations.each do |station|
  puts "Station Name: #{station.name}"
end

# Удаляем станцию из маршрута
route.remove_station(station3)

# Выводим обновленную информацию о станциях в маршруте
puts 'Stations in Route after removal:'
route.stations.each do |station|
  puts "Station Name: #{station.name}"
end
