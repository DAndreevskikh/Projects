# frozen_string_literal: true

require_relative 'validation'
require_relative 'accessors'
require_relative 'train'

class Wagon
  include Validation
  include Accessors

  attr_accessor_with_history :type, :number, :seats, :capacity

  validate :type, :presence
  validate :type, :length, 1, 20

  class << self
    attr_accessor :last_wagon_number

    def increment_last_wagon_number!
      @last_wagon_number ||= 0
      @last_wagon_number += 1
    end
  end

  def initialize(type)
    self.type = type
    @number = generate_wagon_number
    @occupied = 0
  end

  def book_seat
    return unless type == 'passenger'

    @occupied += 1 if @occupied < @capacity
  end

  def occupied_seats
    return 0 unless type == 'passenger'

    @occupied
  end

  def free_seats
    return 0 unless type == 'passenger'

    @capacity - @occupied
  end

  def load_cargo(volume)
    return unless type == 'cargo'

    @occupied += volume if @occupied + volume <= @capacity
  end

  def occupied_volume
    return 0 unless type == 'cargo'

    @occupied
  end

  def free_volume
    return 0 unless type == 'cargo'

    @capacity - @occupied
  end

  private

  def generate_wagon_number
    number = self.class.increment_last_wagon_number!
    "W#{number}"
  end

  def init_passenger(seats_or_capacity)
    @seats = seats_or_capacity
    @capacity = seats_or_capacity
  end

  def init_cargo(seats_or_capacity)
    @seats = nil
    @capacity = seats_or_capacity
  end
end
