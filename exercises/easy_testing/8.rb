# Kind Assertions

require 'minitest/autorun'

class KindTest < Minitest::Test
  def test_if_kind_of_numeric
    value = 2.71828182846

    assert_kind_of Numeric, value
  end
end