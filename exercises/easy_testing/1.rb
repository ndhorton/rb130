# Boolean Assertions

require 'minitest/autorun'

class OddTest < Minitest::Test
  def test_if_value_odd_question
    value = 3

    assert value.odd?, 'value is not odd'
    assert_equal true, value.odd?
  end
end
