# frozen_string_literal: true

require_relative 'wagon'
require_relative 'validation'
require_relative 'accessors'

class PassengerWagon < Wagon
  include Validation
  include Accessors

  attr_accessor_with_history :number, :seats, :occupied_seats

  validate :number, :presence
  validate :seats, :presence
  validate :seats, :positive_integer

  def initialize(seats)
    super(:passenger)
    @seats = seats.to_i
    @occupied_seats = 0
    validate!
  end

  def details
    "Wagon: Type: #{type}, Number: #{number}, Seats: #{seats}, Occupied Seats: #{occupied_seats}"
  end

  def total_seats
    @seats
  end

  def free_seats
    @seats - @occupied_seats
  end

  def take_seat(count = 1)
    if occupied_seats + count <= @seats
      self.occupied_seats += count
      puts "#{count} seat(s) has been taken. Remaining seats: #{@seats - occupied_seats}"
    else
      puts "Not enough available seats. Remaining seats: #{@seats - occupied_seats}"
    end
  end
end
