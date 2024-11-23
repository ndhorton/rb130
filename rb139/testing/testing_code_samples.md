

This example demonstrates a basic test suite.

```ruby
require 'minitest/autorun'

require_relative 'car'

class CarTest < Minitest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end
end
```



This example demonstrates a test that will fail (in this case it is the fault of the test itself rather than the class being tested)

```ruby
require 'minitest/autorun'

require_relative 'car'

class CarTest < Minitest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end

  def test_bad_wheels
    car = Car.new
    assert_equal(3, car.wheels)
  end
end
```



This example demonstrates the `minitest-reporters` gem:

```ruby
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'car'

class CarTest < Minitest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end

  def test_bad_wheels
    car = Car.new
    assert_equal(3, car.wheels)
  end
end
```



This example demonstrates using `skip` to skip a test, perhaps because we have not finished writing the test yet, or for another reason:

```ruby
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'car'

class CarTest < Minitest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end

  def test_bad_wheels
    skip
    car = Car.new
    assert_equal(3, car.wheels)
  end
end
```



A single example of Minitest's optional expectation syntax DSL:

```ruby
require 'minitest/autorun'

require_relative 'car'

describe 'Car#wheels' do
  it 'has 4 wheels' do
    car = Car.new
    _(car.wheels).must_equal 4           # this is the expectation
  end
end
```



This example demonstrates an assertion that will pass since the block raises an exception

```ruby
require 'minitest/autorun'

class Car
  attr_accessor :wheels, :name

  def initialize
    @wheels = 4
  end
end

class CarTest < Minitest::Test
  def test_raise_initialize_with_arg
    assert_raises(ArgumentError) do
      car = Car.new(name: "Joey")         # this code raises ArgumentError, so this assertion passes
    end
  end
end
```



Example demonstrates the SEAT approach (without `#teardown` method):

```ruby
require 'minitest/autorun'

require_relative 'car'

class CarTest < Minitest::Test
  def setup
    @car = Car.new
  end

  def test_car_exists
    assert(@car)
  end

  def test_wheels
    assert_equal(4, @car.wheels)
  end

  def test_name_is_nil
    assert_nil(@car.name)
  end

  def test_raise_initialize_with_arg
    assert_raises(ArgumentError) do
      Car.new(name: "Joey")
    end
  end

  def test_instance_of_car
    assert_instance_of(Car, @car)
  end

  def test_includes_car
    arr = [1, 2, 3]
    arr << @car

    assert_includes(arr, @car)
  end
end
```



This example demonstrates testing for value equality with `assert_equal` and for object equality using `assert_same`:

```ruby
require 'minitest/autorun'

class EqualityTest < Minitest::Test
  def test_value_equality
    str1 = "hi there"
    str2 = "hi there"

    assert_equal(str1, str2)
    assert_same(str1, str2)
  end
end
```



What has happened to generate this failure message? (two different objects have been passed to `assert_same`):

```
  1) Failure:
EqualityTest#test_value_equality [temp.rb:9]:
Expected "hi there" (oid=70321861410720) to be the same as "hi there" (oid=70321861410740).
```



This example demonstrates that without defining a `==` method for a custom class, our `assert_equal` test will fail:

```ruby
class Car
  attr_accessor :wheels, :name

  def initialize
    @wheels = 4
  end
end

class CarTest < Minitest::Test
  def test_value_equality
    car1 = Car.new
    car2 = Car.new

    car1.name = "Kim"
    car2.name = "Kim"

    assert_equal(car1, car2)
  end
end
```



What has happened to generate this failure message? (we have used `assert_equal` on objects of a custom class that does not implement `==`):

```
# Running:

CarTest F

Finished in 0.021080s, 47.4375 runs/s, 47.4375 assertions/s.

  1) Failure:
CarTest#test_value_equality [car_test.rb:48]:
No visible difference in the Car#inspect output.
You should look at the implementation of #== on Car or its members.
#<Car:0xXXXXXX @wheels=4, @name="Kim">

1 runs, 1 assertions, 1 failures, 0 errors, 0 skips
```



What are regression tests and why are they useful?

<details><summary>Answer</summary>Regression tests check for bugs that occur in formerly working code after you make changes somewhere in the codebase. Using tests to identify these bugs means we don't have to verify that everything works manually after each change.</details>
