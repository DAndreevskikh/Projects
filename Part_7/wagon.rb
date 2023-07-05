class Wagon
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def valid?
    !type.nil?
  end
end
