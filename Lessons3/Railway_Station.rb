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

   def train_by_type(type)
    @trains.select{ |train| train.type == type}
   end
end


class Route
  attr_reader :station

  def initialize(starting_station, end_station)
    @station = [starting_station, end_station]
  end

  def add_station(station)
    @station.insert(-2, station)
  end

    def delete_station(station)
      @station.delete(station) unless [@station.first, @station.last].include?(station)
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

  def break(speed)
    @speed -= speed
    if @speed.negative?
       @speed = 0
    end
  end

  def attach_wagons(wagons)
    if @speed > 0
      puts "Slow Down!!"
    else @speed.zero?
      @wagons += wagons
    end
  end

 def unhook_wagons(wagons)
  if @speed > 0
      puts "Slow Down!!"
    else @speed.zero?
      @wagons -= wagons
  end
 end

  def set_route(route)
    @route = route
    @current_station_index = 0
    current_station.add_train(self)
  end
end

  def move_forvard
    return unless next_station
    current_station.remove_train(self)
    @current_station_index += 1
    current_station.add_train(self)
  end

 def current_station
   route.station[@current_station_index]
 end

  def previous_station
  route.station[@current_station_index - 1]
  if @current_station_index.positive?
  end

  def next_station
    route.station[@current_station_index + 1]
    if @current_station_index < route.station.size - 1
    end

    def move_backward
      return unless previous_station
      current_station.remove_train(self)
      @current_station -= 1
      current_station.add_train(self)
    end
  end
  end
