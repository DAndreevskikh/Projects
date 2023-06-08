class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station] # Массив для хранения станций маршрута
  end
  # Возвращает первую станцию в маршруте
  def start_station
    @stations.first
  end
  # Возвращает последнюю станцию в маршруте
  def end_station
    @stations.last
  end

 def delete_station(station)
    @stations.delete(station) # Удаляет указанную станцию из маршрута
  end
end
