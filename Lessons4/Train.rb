class Train
  attr_reader :number, :type, :wagons, :speed, :current_station, :route

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
  end

  def speed_up(speed)
    @speed += speed
  end

  def break(speed)
    @speed -= speed
    @speed = 0 if @speed.negative?
  end

  def attach_wagon(wagon)
    if wagon.type == self.type
      wagons << wagon
    else
      puts "Cannot attach a #{wagon.type} wagon to a #{self.type} train."
    end
  end

  def detach_wagon(wagon)
    wagons.delete(wagon)
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

  protected #Так как они используются внутри класса и в его подклассах для получения предыдущей и следующей станции на маршруте. Они не предназначены для использования извне.

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
