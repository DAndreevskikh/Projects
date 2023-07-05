require_relative 'validation'

class Train
  include Validation

  attr_reader :number, :type

  def initialize(number, type)
    @number = number
    @type = type
    valid?
  end

  def valid?
   validate!
  true
rescue
  false
end



  private

  def validate!
    validate_presence('Train number', number)
    validate_presence('Train type', type)
    validate_format('Train type', type.to_s, /^[a-z]+$/)
  end
end
