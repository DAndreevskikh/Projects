# frozen_string_literal: true

require_relative 'train'
require_relative 'accessors'

class PassengerTrain < Train
  include Accessors

  def initialize(number)
    super(number, :passenger)
  end
end
