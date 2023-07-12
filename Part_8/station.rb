require_relative 'validation'
require_relative 'instance_counter'

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  def initialize(name)
    @name = name
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

  def validate!
    validate_presence('Station name', name)
    validate_length('Station name', name, 1, 100)
  end
end
