require_relative 'validation'

class Route
  include Validation

  attr_reader :stations

  def initialize(start_station, end_station)
    validate_station(start_station)
    validate_station(end_station)
    @stations = [start_station, end_station]
    validate!
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    raise "Can't remove start or end station from the route." if [stations.first, stations.last].include?(station)

    @stations.delete(station)
  end

  private

  def validate_station(station)
    raise 'Invalid station.' unless station.is_a?(Station) && station.valid?
  end

  def validate!
    validate_presence('Start station', stations.first)
    validate_presence('End station', stations.last)
  end
end
