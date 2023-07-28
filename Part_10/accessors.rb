# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each { |name| define_history_accessors(name) }
    end

    def strong_attr_accessor(name, type)
      define_history_accessors(name)
      define_method("#{name}=") do |value|
        raise TypeError, "Invalid type. Expected #{type}" unless value.is_a?(type)

        instance_variable_set("@#{name}", value)
      end
    end

    private

    def define_history_accessors(name)
      var_name = "@#{name}"
      history_var_name = "@#{name}_history"

      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}_history") { instance_variable_get(history_var_name) || [] }

      define_method("#{name}=") do |value|
        history = instance_variable_get(history_var_name) || []
        history << instance_variable_get(var_name) unless history.include?(instance_variable_get(var_name))
        instance_variable_set(history_var_name, history)

        instance_variable_set(var_name, value)
      end
    end
  end
end
