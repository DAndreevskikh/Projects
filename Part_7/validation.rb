module Validation
  def validate_presence(attribute, value)
    raise "Invalid #{attribute} presence." if value.nil? || value.to_s.empty?
  end

  def validate_format(attribute, value, format)
    raise "Invalid #{attribute} format." unless value.to_s.match?(format)
  end
end
