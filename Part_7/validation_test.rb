require_relative 'train'
require_relative 'station'
require_relative 'validation'

# Testing Validation module
class ValidationTest
  include Validation

  def run_tests
    test_presence_validation
    test_format_validation
    test_train_validation
    test_station_validation
  end

  private

  def assert_equal(expected, actual, message)
    if expected == actual
      puts "PASS: #{message}"
    else
      puts "FAIL: #{message} (Expected: #{expected}, Actual: #{actual})"
    end
  end

  def assert_raise(expected_error, message)
    begin
      yield
    rescue expected_error
      puts "PASS: #{message}"
      return
    rescue => e
      puts "FAIL: #{message} (Expected: #{expected_error}, Actual: #{e.class})"
      return
    end

    puts "FAIL: #{message} (Expected: #{expected_error}, No exception was raised)"
  end

  def test_presence_validation
    assert_raise(RuntimeError, 'Presence validation failed') do
      validate_presence('attribute', nil)
    end

    assert_raise(RuntimeError, 'Presence validation failed') do
      validate_presence('attribute', '')
    end

    assert_raise(RuntimeError, 'Presence validation failed') do
      validate_presence('attribute', '   ')
    end

    assert_equal(true, validate_presence('attribute', 'value'), 'Presence validation passed')
  end

  def test_format_validation
    assert_raise(RuntimeError, 'Format validation failed') do
      validate_format('attribute', '123', /^[a-z]+$/)
    end

    assert_raise(RuntimeError, 'Format validation failed') do
      validate_format('attribute', 'abc', /^[0-9]+$/)
    end

    assert_equal(true, validate_format('attribute', 'abc', /^[a-z]+$/), 'Format validation passed')
    assert_equal(true, validate_format('attribute', '123', /^[0-9]+$/), 'Format validation passed')
  end

  def test_train_validation
    assert_equal(false, Train.new('123', '').valid?, 'Train validation failed')
    assert_equal(false, Train.new('', 'passenger').valid?, 'Train validation failed')
    assert_equal(false, Train.new('123', 'invalid').valid?, 'Train validation failed')
    assert_equal(false, Train.new('12-34', 'cargo').valid?, 'Train validation failed')
    assert_equal(true, Train.new('12345', 'passenger').valid?, 'Train validation passed')
  end

  def test_station_validation
    assert_equal(false, Station.new('').valid?, 'Station validation failed')
    assert_equal(false, Station.new('   ').valid?, 'Station validation failed')
    assert_equal(true, Station.new('Station 1').valid?, 'Station validation passed')
  end
end

test = ValidationTest.new
test.run_tests
