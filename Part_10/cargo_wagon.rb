# frozen_string_literal: true

require_relative 'wagon'
require_relative 'validation'
require_relative 'accessors'

class CargoWagon < Wagon
  include Validation
  include Accessors

  attr_accessor_with_history :number, :capacity, :occupied_capacity

  validate :number, :presence
  validate :capacity, :presence

  def initialize(capacity)
    super('cargo')
    @occupied_capacity = 0.0
    @capacity = capacity
    validate!
  rescue StandardError => e
    puts e.message
  end

  def take_volume(volume)
    available_capacity = capacity - occupied_capacity.to_f
    raise "Not enough capacity. Available: #{available_capacity}" unless volume <= available_capacity

    self.occupied_capacity += volume
  end

  def total_volume
    @capacity
  end

  def free_volume
    @capacity - @occupied_capacity
  end

  def details
    "Wagon: Type: #{type}, Number: #{number}, Capacity: #{capacity}, Occupied Volume: #{occupied_capacity}"
  end
end
