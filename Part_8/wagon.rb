require_relative 'validation'

class Wagon
  include Validation

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  private

  def validate!
    validate_presence('Wagon type', @type)
    validate_length('Wagon type', @type.to_s, 1, 20)
  end
end
