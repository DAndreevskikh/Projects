# frozen_string_literal: true

require_relative 'validation'
require_relative 'accessors'
require_relative 'station'

class Route
  include Validation
  include Accessors

  attr_accessor_with_history :stations
  strong_attr_accessor :start_station, Station
  strong_attr_accessor :end_station, Station

  def initialize(start_station, end_station)
    self.start_station = start_station
    self.end_station = end_station
    @stations = [start_station, end_station]
    validate!
  end

  def add_station(station)
    @stations.insert(-2, station) unless @stations.include?(station)
  end

  def remove_station(station)
    return if [start_station, end_station].include?(station)

    @stations.delete(station)
  end

  def details
    "Route: #{start_station.name} -> #{end_station.name}"
  end

  def validate!
    validate_type('Start station', start_station, Station)
    validate_type('End station', end_station, Station)
    validate_presence('Start station', start_station)
    validate_presence('End station', end_station)
    validate_stations_uniqueness
  end

  def validate_stations_uniqueness
    duplicates = stations.group_by(&:itself).select { |_, group| group.size > 1 }
    return if duplicates.empty?

    station_names = duplicates.keys.map { |station| "Station '#{station.name}'" }.join(', ')
    raise "#{station_names} #{duplicates.size == 1 ? 'is' : 'are'} duplicated in the route."
  end
end
