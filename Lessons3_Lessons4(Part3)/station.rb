require_relative 'instance_counter'

class Station
  include InstanceCounter
   @@stations = []

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @@stations << self
    @trains = [] # Массив для хранения поездов, находящихся на станции
    register_instance
  end

  def self.all
    @@stations
  end

  # Принимает поезд на станцию
  def take_train(train)
    @trains << train
  end
  # Удаляет поезд из списка поездов на станции
  def delete_train(train)
    @trains.delete(train)
  end
  # Возвращает список поездов на станции по типу
  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end
end
