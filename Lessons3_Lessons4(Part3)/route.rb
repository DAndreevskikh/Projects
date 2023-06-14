require_relative 'instance_counter'

class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station] # Массив для хранения станций маршрута
    register_instance
  end
  # Возвращает первую станцию в маршруте
  def start_station
    @stations.first
  end
  # Возвращает последнюю станцию в маршруте
  def end_station
    @stations.last
  end

  def add_station(station)
    @stations.insert(-2, station) # Вставляем станцию перед конечной станцией
  end

 def delete_station(station)
    @stations.delete(station) # Удаляет указанную станцию из маршрута
  end
end
