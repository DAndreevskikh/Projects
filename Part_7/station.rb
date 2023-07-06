require_relative 'validation'

class Station
  include Validation

  attr_reader :name, :trains

  def initialize(name)
    @name = name.to_s
    validate!
    @trains = []
  end

  private

  def validate!
    validate_presence('Station name', name)
    validate_length('Station name', name, 1, 100)
  end
end
