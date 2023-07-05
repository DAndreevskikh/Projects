require_relative 'validation'

class Station
  include Validation

  attr_reader :name, :trains

  def initialize(name)
    @name = name.to_s
    valid?
    @trains = []
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  private

  def validate!
    validate_presence('station name', name)
  end
end
