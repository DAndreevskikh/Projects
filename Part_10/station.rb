# frozen_string_literal: true

require_relative 'validation'
require_relative 'instance_counter'
require_relative 'accessors'

class Station
  include InstanceCounter
  include Validation
  include Accessors

  attr_accessor_with_history :trains, :name

  validate :name, :presence
  validate :name, :length, 1, 100

  class << self
    attr_accessor :all_stations
  end

  self.all_stations = []

  def initialize(name)
    self.name = name
    @trains = []
    self.class.all_stations << self
    validate!
    register_instance
  end

  def self.all
    all_stations
  end

  def name_history
    @name_history || []
  end

  def each_train(&block)
    @trains.each(&block)
  end

  def add_train(train)
    @trains << train
  end

  def details
    "Station: #{@name}, Trains: #{@trains}"
  end

  def remove_train(train)
    @trains.delete(train)
  end
end
