require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'validation'

# Testing Validation module
class ValidationTest
  include Validation

  def run_tests
    test_train_validation
    test_station_validation
    test_route_validation
    test_wagon_validation
  end

  private

  def assert_equal(expected, actual, message)
    if expected == actual
      puts "PASS: #{message}"
    else
      puts "FAIL: #{message} (Expected: #{expected}, Actual: #{actual})"
    end
  end

  def test_train_validation
    puts 'Testing train validation...'
    assert_equal(true, valid_train?('12345', 'passenger'), 'Valid passenger train created')
    assert_equal(false, valid_train?('1234', 'cargo'), 'Invalid cargo train created')
    puts '------------------------------'
  end

  def test_station_validation
    puts 'Testing station validation...'
    assert_equal(true, valid_station?('Station A'), 'Valid station created')
    assert_equal(false, valid_station?(''), 'Invalid station not created')
    puts '------------------------------'
  end

  def test_route_validation
    puts 'Testing route validation...'
    assert_equal(true, valid_route?('Station A', 'Station B'), 'Valid route created')
    assert_equal(false, valid_route?('Station A', 'Station A'), 'Invalid route created')
    puts '------------------------------'
  end

  def test_wagon_validation
    puts 'Testing wagon validation...'
    assert_equal(true, valid_wagon?('passenger'), 'Valid passenger wagon created')
    assert_equal(false, valid_wagon?('cargo'), 'Invalid cargo wagon created')
    puts '------------------------------'
  end

  def valid_train?(number, type)
    train = Train.new(number, type)
    train.valid?
  rescue => e
    puts "Error creating train: #{e.message}"
    false
  end

  def valid_station?(name)
    station = Station.new(name)
    station.valid?
  rescue => e
    puts "Error creating station: #{e.message}"
    false
  end

  def valid_route?(start_station, end_station)
    route = Route.new(start_station, end_station)
    route.valid?
  rescue => e
    puts "Error creating route: #{e.message}"
    false
  end

  def valid_wagon?(type)
    wagon = Wagon.new(type)
    wagon.valid?
  rescue => e
    puts "Error creating wagon: #{e.message}"
    false
  end
end

test = ValidationTest.new
test.run_tests
