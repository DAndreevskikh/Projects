# frozen_string_literal: true

require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :total_volume, :occupied_volume

  def initialize(total_volume)
    super(:cargo)
    @total_volume = total_volume
    @occupied_volume = 0
  end

  def available_volume
    @total_volume - @occupied_volume
  end

  def occupy_volume(volume)
    @occupied_volume += volume if @occupied_volume + volume <= @total_volume
  end

  def free_volume
    @total_volume - @occupied_volume
  end
end
