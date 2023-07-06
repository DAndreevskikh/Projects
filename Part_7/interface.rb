class Interface
  def initialize
    @trains = []
    @stations = []
    @routes = []
    @wagons = []
  end

  def create_train
    begin
      puts 'Enter the train number:'
      number = gets.chomp
      puts 'Enter the train type (passenger/cargo):'
      type = gets.chomp

      train = Train.new(number, type)
      @trains << train

      puts "Train created: Number - #{train.number}, Type - #{train.type}"
    rescue => e
      puts e
    end
  end

  def create_station
    begin
      puts 'Enter the station name:'
      name = gets.chomp

      station = Station.new(name)
      @stations << station

      puts "Station created: #{station.name}"
    rescue => e
      puts e
    end
  end

  def create_route
    begin
      puts 'Enter the start station name:'
      start_station_name = gets.chomp
      puts 'Enter the end station name:'
      end_station_name = gets.chomp

      start_station = find_or_create_station(start_station_name)
      end_station = find_or_create_station(end_station_name)

      route = Route.new(start_station, end_station)
      @routes << route

      puts "Route created: Start station - #{route.stations.first.name}, End station - #{route.stations.last.name}"
    rescue => e
      puts e
    end
  end

  def create_wagon
    begin
      puts 'Enter the wagon type (passenger/cargo):'
      type = gets.chomp

      wagon = Wagon.new(type)
      @wagons << wagon

      puts "Wagon created: Type - #{wagon.type}"
    rescue => e
      puts e
    end
  end
end
