# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def validate(name, type, *args)
      @validations ||= []
      @validations << { attribute: name, type: type, args: args }
    end
  end

  def validate!
    ensure_validations_initialized
    errors = []

    self.class.instance_variable_get(:@validations).each do |validation|
      errors.concat(process_validation(validation))
    end

    raise errors.join("\n") unless errors.empty?
  end

  def ensure_validations_initialized
    return if self.class.instance_variable_defined?(:@validations)

    self.class.instance_variable_set(:@validations, [])
  end

  def process_validation(validation)
    errors = []
    attribute = validation[:attribute]
    value = instance_variable_get("@#{attribute}")
    Array(validation[:type]).each do |type|
      send("validate_#{type}", attribute, value, *validation[:args])
    rescue StandardError => e
      errors << e.message
    end
    errors
  end

  def validate_presence(attribute, value)
    raise "Invalid #{attribute} presence." if value.to_s.strip.empty?
  end

  def validate_positive_integer(attribute, value)
    raise "Invalid #{attribute} format." unless value.is_a?(Integer) && value.positive?
  end

  def validate_type(attribute, value, *klasses)
    raise "Invalid #{attribute} type." unless klasses.any? { |klass| value.is_a?(klass) }
  end

  def validate_length(name, value, min_length, max_length)
    raise "Invalid #{name} length." unless value.to_s.length.between?(min_length, max_length)
  end

  def validate_positive(attribute, value)
    raise "Invalid #{attribute} format." unless value.is_a?(Numeric) && value.positive?
  end

  def validate_positive_float(attribute, value)
    raise "Invalid #{attribute} format." unless value.is_a?(Float) && value.positive?
  end

  def validate_format(attribute, value, format)
    raise "Invalid #{attribute} format." unless value.to_s.match?(format)
  end

  def validate_capacity(attribute, value)
    value = value.to_f
    errors = []

    errors << "Invalid #{attribute} presence." if value <= 0

    return if errors.empty?

    raise errors.join("\n")
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
