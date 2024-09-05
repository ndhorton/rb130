# Type Assertions

require 'minitest/autorun'

class TypeTest < Minitest::Test
  def test_if_instance_of_numeric_class
    value = Numeric.new

    assert_instance_of Numeric, value
  end
end