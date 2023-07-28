# frozen_string_literal: true

require_relative 'validation'
require_relative 'instance_counter'
require_relative 'accessors'

class Station
  include InstanceCounter
  include Validation
  include Accessors

  attr_accessor_with_history :trains
  strong_attr_accessor :name, String

  validate :name, :presence
  validate :name, :length, 1, 100

  def initialize(name)
    self.name = name
    @trains = []
    validate!
    register_instance
  end

  def each_train(&block)
    @trains.each(&block)
  end

  def add_train(train)
    @trains << train
  end

  def remove_train(train)
    @trains.delete(train)
  end
end
