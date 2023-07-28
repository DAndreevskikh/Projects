# frozen_string_literal: true

require_relative 'accessors'

class TestAccessors
  include Accessors

  attr_accessor_with_history :name, :number
  strong_attr_accessor :type, Symbol

  def initialize(name, number, type)
    @name = name
    @number = number
    @type = type
  end
end

# Create test objects

train1 = TestAccessors.new('Train 1', 'ABC123', :passenger)
train2 = TestAccessors.new('Train 2', 'DEF456', :cargo)

# Modify attributes to trigger history recording
train1.name = 'Modified Train 1 Name'
train1.number = 'MOD123'

train2.name = 'Modified Train 2 Name'
train2.number = 'MOD456'

puts "Train 1 name history: #{train1.name_history.inspect}"
puts "Train 1 number history: #{train1.number_history.inspect}"

puts "Train 2 name history: #{train2.name_history.inspect}"
puts "Train 2 number history: #{train2.number_history.inspect}"

# Checking strong_attr_accessor

begin
  train3 = TestAccessors.new('Train 3', 'GHI789', :passenger) # Invalid type for type
  puts "Train 3 name: #{train3.name}, number: #{train3.number}, type: #{train3.type}"
rescue TypeError => e
  puts "Error assigning a value to the attribute type: #{e.message}"
end

# Define a method to modify attributes and print history
def modify_attribute_and_print_history(object, attribute, new_value)
  puts "Current #{attribute}: #{object.send(attribute)}"
  object.send("#{attribute}=", new_value)
  puts "New #{attribute}: #{object.send(attribute)}"
  puts "#{attribute.to_s.capitalize} history: #{object.send("#{attribute}_history").inspect}"
end

# Modify attributes for Train 1 and print history
modify_attribute_and_print_history(train1, :name, 'New Train 1 Name')
modify_attribute_and_print_history(train1, :number, 'NEW123')
