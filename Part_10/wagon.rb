# frozen_string_literal: true

require_relative 'validation'
require_relative 'accessors'

class Wagon
  include Validation
  include Accessors

  attr_accessor_with_history :type

  validate :type, :presence
  validate :type, :length, 1, 20

  def initialize(type)
    self.type = type
    validate!
  end
end
