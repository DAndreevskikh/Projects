require_relative 'validation'

class Train
  include Validation

  attr_reader :number, :type

  def initialize(number, type)
    @number = number
    @type = type
    validate!
  end

  private

  def validate!
    validate_presence('Train number', number)
    validate_presence('Train type', type)
    validate_format('Train number', number.to_s, /^[a-z0-9]+$/i)
    validate_format('Train type', type.to_s, /^(passenger|cargo)$/i)
  end
end
