require_relative 'validation'

class Route
  include Validation

  attr_reader :stations

  def initialize(start_station, end_station)
    validate_station(start_station)
    validate_station(end_station)
    @stations = [start_station, end_station]
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
