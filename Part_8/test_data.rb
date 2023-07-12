require_relative 'train'
require_relative 'wagon'
require_relative 'station'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

# Создание тестовых данных
station1 = Station.new("Station 1")
station2 = Station.new("Station 2")
station3 = Station.new("Station 3")

train1 = Train.new("ABC123", :passenger)
train2 = Train.new("DEF456", :cargo)
train3 = Train.new("GHI789", :passenger)

wagon1 = PassengerWagon.new(30)
wagon2 = CargoWagon.new(500)
wagon3 = PassengerWagon.new(20)

train1.attach_wagon(wagon1)
train1.attach_wagon(wagon3)
train2.attach_wagon(wagon2)
train3.attach_wagon(wagon1)

station1.add_train(train1)
station1.add_train(train2)
station2.add_train(train3)

# Вывод информации о станциях, поездах и вагонах
stations = [station1, station2, station3]

stations.each do |station|
  puts "Station: #{station.name}"

  station.each_train do |train|
    puts "Train: #{train.number}, Type: #{train.type}, Wagons: #{train.wagons.size}"

    train.each_wagon do |wagon|
      if wagon.is_a?(PassengerWagon)
        puts "  Wagon: #{wagon.type}, Free seats: #{wagon.free_seats}, Occupied seats: #{wagon.occupied_seats}"
      elsif wagon.is_a?(CargoWagon)
        puts "  Wagon: #{wagon.type}, Free volume: #{wagon.free_volume}, Occupied volume: #{wagon.occupied_volume}"
      end
    end
  end

  puts ""
end
