require_relative 'validation'
require_relative 'manufacturer'
require_relative 'instance_counter'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  @@trains = []
  attr_accessor :number
  attr_reader :type, :wagons, :speed, :current_station, :route

  def initialize(number, type)
    @number = number
    @type = type.to_sym
    @wagons = []
    @speed = 0
    @@trains << self
    validate!
    register_instance
  end

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def speed_up(speed)
    @speed += speed
  end

  def break(speed)
    @speed -= speed
    @speed = 0 if @speed.negative?
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

  def set_route(route)
    @route = route
    @current_station = 0
    current_station.add_train(self)
  end

  def move_forward
    return unless next_station

    current_station.remove_train(self)
    @current_station += 1
    current_station.add_train(self)
  end

  def move_backward
    return unless previous_station

    current_station.remove_train(self)
    @current_station -= 1
    current_station.add_train(self)
  end

  def current_station
    return unless @route

    @route.stations[@current_station]
  end

  def previous_station
    return unless @route

    @route.stations[@current_station - 1] if @current_station.positive?
  end

  def next_station
    return unless @route

    @route.stations[@current_station + 1] if @current_station < @route.stations.size - 1
  end

  private

  def validate_wagon_type(wagon)
    return if wagon.type == type

    raise 'Wagon type does not match train type.'
  end

  def validate!
    validate_presence('Train number', number)
    validate_presence('Train type', type)
    validate_format('Train number', number.to_s, /^[a-z0-9]+$/i)
    validate_format('Train type', type.to_s, /^(passenger|cargo)$/i)
  end
end
