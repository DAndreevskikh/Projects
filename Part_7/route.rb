require_relative 'validation'

class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    validate_station(start_station)
    validate_station(end_station)
    @stations = [start_station, end_station]
  end

  def valid?
    true
  end

  private

  def validate_station(station)
    raise "Invalid station." unless station.is_a?(Station) && station.valid?
  end
end
