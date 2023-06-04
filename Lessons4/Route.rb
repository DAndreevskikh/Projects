class Route
  attr_reader :stations

  def initialize(starting_station, end_station)
    @stations = [starting_station, end_station]
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  protected #В данном случае, используется  для удаления станции, и предполагается, что этот метод может быть использован в методах класса и подклассов.

  def delete_station(station)
    stations.delete(station) unless [stations.first, stations.last].include?(station)
  end
end
