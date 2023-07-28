# frozen_string_literal: true

require_relative 'train'
require_relative 'wagon'
require_relative 'station'
require_relative 'route'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

# Тестирование модуля Accessors

class TestTrain
  include Accessors

  attr_accessor_with_history :name
  strong_attr_accessor :number, String
  strong_attr_accessor :type, Symbol

  def initialize(name, number, type)
    @name = name
    @number = number
    @type = type
  end
end

# Создаем объекты для тестирования

train1 = TestTrain.new('Train 1', 'ABC123', :passenger)
train2 = TestTrain.new('Train 2', 'DEF456', :cargo)

puts "Train 1 name: #{train1.name}, number: #{train1.number}, type: #{train1.type}"
puts "Train 2 name: #{train2.name}, number: #{train2.number}, type: #{train2.type}"

train1.name = 'New Train 1 Name'
train2.number = 'NewTrain456'
train1.type = :cargo

puts "Train 1 name history: #{train1.name_history}"
puts "Train 2 number history: #{train2.number_history}"
