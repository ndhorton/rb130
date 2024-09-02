require 'minitest/autorun'
require 'minitest/reporters'

require_relative 'car.rb'

# Minitest::Reporters.use!

class CarTest < Minitest::Test
  def test_car_exists
    car = Car.new
    assert(car)
  end

  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end

  def test_name_is_nil
    car = Car.new
    assert_nil(car.name)
  end

  def test_raise_initialize_with_arg
    assert_raises(ArgumentError) do
      car = Car.new(name: "Joey")  # this code raises ArgumentError
    end                            # so the test passes
  end

  def test_instance_of_car
    car = Car.new
    assert_instance_of(Car, car)  # more useful when dealing with inheritance
  end

  def test_includes_car
    car = Car.new
    arr = [1, 2, 3]
    arr << car

    assert_includes(arr, car)
  end
end