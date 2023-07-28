module Validation
  def validate_presence(attribute, value)
    raise "Invalid #{attribute} presence." if value.nil? || value.to_s.strip.empty?
  end

  def validate_length(attribute, value, min_length, max_length)
    raise "Invalid #{attribute} length." unless value.to_s.length.between?(min_length, max_length)
  end

  def validate_format(attribute, value, format)
    raise "Invalid #{attribute} format." unless value.to_s.match?(format)
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
