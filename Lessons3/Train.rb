class Train
  attr_reader :number, :type, :wagons, :speed, :current_station, :route

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = [] # Массив для хранения вагонов, прицепленных к поезду
    @speed = 0 # Текущая скорость поезда
  end
   # Увеличивает скорость поезда
  def speed_up(speed)
    @speed += speed
  end
  # Уменьшает скорость поезда до 0
  def break(speed)
    @speed -= speed
    @speed = 0 if @speed.negative?
  end
   # Прицепляет вагон к поезду
  def attach_wagon(wagon)
    if wagon.type == type
      if wagons.count < max_wagons
        wagons << wagon
        puts "A #{wagon.type} wagon has been attached to the train."
      else
        puts "Cannot attach a #{wagon.type} wagon. The train already has the maximum number of #{wagon.type} wagons."
      end
    else
      puts "Cannot attach a #{wagon.type} wagon to a #{type} train."
    end
  end
  # Отсоединяет вагон от поезда
  def detach_wagon
    if wagons.empty?
      puts "No wagons to detach."
    else
      wagon = wagons.last
      wagons.delete(wagon)
      puts "A #{wagon.type} wagon has been detached from the train."
    end
  end
  # Назначает маршрут поезду
  def set_route(route)
    @route = route
    @current_station_index = 0
    current_station.take_train(self)
  end
  # Перемещает поезд вперед по маршруту
  def move_forward
    return unless next_station

    current_station.delete_train(self)
    @current_station_index += 1
    current_station.take_train(self)
  end
  # Перемещает поезд назад по маршруту
  def move_backward
    return unless previous_station

    current_station.delete_train(self)
    @current_station_index -= 1
    current_station.take_train(self)
  end
  # Возвращает название текущей станции, если она есть
  def current_station_name
    current_station.name if current_station
  end
   # Возвращает следующую станцию на маршруте, если она существует
  def next_station
    route.stations[@current_station_index + 1] if @current_station_index < route.stations.size - 1
  end
  # Возвращает предыдущую станцию на маршруте, если она существует
  def previous_station
    route.stations[@current_station_index - 1] if @current_station_index.positive?
  end

  protected
  # Возвращает максимальное количество вагонов в зависимости от типа поезда
  def max_wagons
    if type == :passenger
      10
    elsif type == :cargo
      15
    end
  end
  # Возвращает текущую станцию на маршруте
  def current_station
    route.stations[@current_station_index]
  end
end


