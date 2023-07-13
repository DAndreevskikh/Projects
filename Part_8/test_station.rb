require_relative 'station'
require_relative 'train'
require_relative 'route'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'


# Создаем станцию
station = Station.new("Station 1")

# Выводим информацию о станции
puts "Station Name: #{station.name}"
puts "Station Trains: #{station.trains}"

# Добавляем поезда на станцию
train1 = Train.new("ABC123", :passenger)
train2 = Train.new("DEF456", :cargo)
station.add_train(train1)
station.add_train(train2)

# Выводим информацию о поездах на станции
puts "Trains at Station:"
station.each_train do |train|
  puts "Train Number: #{train.number}, Type: #{train.type}"
end

# Удаляем поезд со станции
station.remove_train(train1)

# Выводим обновленную информацию о поездах на станции
puts "Trains at Station after removal:"
station.each_train do |train|
  puts "Train Number: #{train.number}, Type: #{train.type}"
end
