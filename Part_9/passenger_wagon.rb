# frozen_string_literal: true

require_relative 'wagon'

class PassengerWagon < Wagon
  attr_reader :total_seats, :occupied_seats

  def initialize(total_seats)
    super(:passenger)
    @total_seats = total_seats
    @occupied_seats = 0
  end

  def available_seats
    @total_seats - @occupied_seats
  end

  def occupy_seat
    @occupied_seats += 1 if @occupied_seats < @total_seats
  end

  def free_seats
    @total_seats - @occupied_seats
  end
end
