# frozen_string_literal: true

require_relative 'train'
require_relative 'accessors'

class CargoTrain < Train
  include Accessors

  def initialize(number)
    super(number, :cargo)
  end
end
