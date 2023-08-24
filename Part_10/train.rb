# frozen_string_literal: true

require_relative 'validation'
require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'wagon'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  include Accessors

  attr_accessor_with_history :number
  strong_attr_accessor :type, Symbol
  attr_reader :wagons, :speed, :current_station, :route

  validate :number, :presence
  validate :number, :format, /^[a-z0-9]+$/i
  validate :type, :presence
  validate :type, :format, /^(passenger|cargo)$/i

  def initialize(number, type)
    @number = number
    @type = type.to_sym
    @wagons = []
    @speed = 0
    self.class.all_trains << self
    validate!
    register_instance
  end

  class << self
    def all_trains
      @all_trains ||= []
    end

    def find(number)
      @all_trains.find { |train| train.number == number }
    end
  end

  def add_wagon(wagon)
    wagons << wagon
  end

  def speed_up(speed)
    @speed += speed
  end

  def brake(speed)
    @speed = [@speed - speed, 0].max
  end

  def each_wagon(&block)
    @wagons.each(&block)
  end

  def attach_wagon(wagon)
    validate_wagon_type(wagon)
    @wagons << wagon
  end

  def detach_wagon
    @wagons.pop
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon) if @speed.zero?
  end

  def route=(route)
    @route = route
    @current_station&.remove_train(self)
    @current_station = 0
    @current_station = @route.stations.first if @route
    current_station&.add_train(self) if @route && current_station.is_a?(Station)
  end

  def move_forward
    return unless next_station && current_station.is_a?(Station)

    current_station.remove_train(self)
    next_index = @route.stations.index(@current_station) + 1
    return unless next_index < @route.stations.size

    @current_station = @route.stations[next_index]
    current_station.add_train(self)
  end

  def move_backward
    return unless previous_station && current_station.is_a?(Station)

    current_station.remove_train(self)
    prev_index = @route.stations.index(@current_station) - 1
    return unless prev_index >= 0

    @current_station = @route.stations[prev_index]
    current_station.add_train(self)
  end

  def previous_station
    return unless @route

    prev_index = @route.stations.index(@current_station) - 1
    @route.stations[prev_index] if prev_index >= 0
  end

  def next_station
    return unless @route

    next_index = @route.stations.index(@current_station) + 1
    @route.stations[next_index] if next_index < @route.stations.size
  end

  def details
    "Train: #{@number}, Type: #{@type}, Wagons: #{wagons.size}"
  end

  private

  def validate_wagon_type(wagon)
    raise 'Wagon type does not match train type.' unless wagon.type.to_sym == type
  end

  def validate!
    validate_presence(:number, number)
    validate_presence(:type, type)
    validate_format(:number, number.to_s, /^[a-z0-9]+$/i)
    validate_format(:type, type.to_s, /^(passenger|cargo)$/i)
  end
end
