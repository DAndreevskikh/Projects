class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def take_the_train(train)
    @trains << train
  end

  def delete_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end
end

class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station) unless [@stations.first, @stations.last].include?(station)
  end
end

class Train
  attr_reader :number, :type, :wagons, :speed, :current_station, :route

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @wagons = wagons
    @speed = 0
  end

  def speed_up(speed)
    @speed += speed
  end

  def brake(speed)
    @speed -= speed
    @speed = 0 if @speed.negative?
  end

  def attach_wagons(wagons)
    if @speed > 0
      puts "Slow Down!"
    else
      @wagons += wagons
    end
  end

  def unhook_wagons(wagons)
    if @speed > 0
      puts "Slow Down!"
    else
      @wagons -= wagons
    end
  end

  def set_route(route)
    @route = route
    @current_station_index = 0
    current_station.take_the_train(self)
  end

  def move_forward
    return unless next_station

    current_station.delete_train(self)
    @current_station_index += 1
    current_station.take_the_train(self)
  end

  def move_backward
    return unless previous_station

    current_station.delete_train(self)
    @current_station_index -= 1
    current_station.take_the_train(self)
  end

  def current_station
    route.stations[@current_station_index]
  end

  def previous_station
    route.stations[@current_station_index - 1] if @current_station_index.positive?
  end

  def next_station
    route.stations[@current_station_index + 1] if @current_station_index < route.stations.size - 1
  end
end
