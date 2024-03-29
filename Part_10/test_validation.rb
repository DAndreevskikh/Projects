# frozen_string_literal: true

require_relative 'train'
require_relative 'wagon'
require_relative 'station'
require_relative 'route'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'accessors'
require_relative 'validation'

# Тестирование модуля Validation
class TestValidation
  include Validation

  attr_accessor :name, :number, :type

  validate :name, :presence
  validate :name, :format, /^[a-zA-Z0-9]+$/
  validate :number, :presence
  validate :number, :format, /^[a-zA-Z0-9]+$/
  validate :type, :presence
  validate :type, :format, /^(passenger|cargo)$/i

  def initialize(name, number, type)
    @name = name
    @number = number
    @type = type
  end
end

# Создаем объекты для тестирования
train1 = TestValidation.new('Train1', 'ABC123', :passenger)
train2 = TestValidation.new('Train2', 'DEF456', :cargo)

puts "Train 1 name: #{train1.name}, number: #{train1.number}, type: #{train1.type}, valid?: #{train1.valid?}"
puts "Train 2 name: #{train2.name}, number: #{train2.number}, type: #{train2.type}, valid?: #{train2.valid?}"

begin
  train3 = TestValidation.new(nil, 'InvalidTrainNumber!', :invalid_type)
  puts "Train 3 name: #{train3.name}, number: #{train3.number}, type: #{train3.type}, valid?: #{train3.valid?}"
rescue StandardError => e
  puts "Error for Train 3: #{e.message}"
end
