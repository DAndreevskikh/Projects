# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def validate(name, type, *args)
      @validations ||= []
      @validations << { name: name, type: type, args: args }
    end
  end

  def validate!
    self.class.instance_variable_set(:@validations, []) unless self.class.instance_variable_defined?(:@validations)
    self.class.instance_variable_get(:@validations).each do |validation|
      value = instance_variable_get("@#{validation[:name]}")
      send("validate_#{validation[:type]}", validation[:name], value, *validation[:args])
    end
  end

  protected

  def validate_presence(name, value)
    raise "Invalid #{name} presence." if value.nil? || value.to_s.strip.empty?
  end

  def validate_length(name, value, min_length, max_length)
    raise "Invalid #{name} length." unless value.to_s.length.between?(min_length, max_length)
  end

  def validate_positive_integer(name, value)
    raise "Invalid #{name} format." unless value.to_i.to_s == value.to_s && value.to_i.positive?
  end

  def validate_format(name, value, format)
    raise "Invalid #{name} format." unless value.to_s.match?(format)
  end

  def validate_type(name, value, klass)
    raise "Invalid #{name} type." unless value.is_a?(klass)
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
