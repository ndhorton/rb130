# Equality Assertions

require 'minitest/autorun'

class EqualityTest < Minitest::Test
  def test_downcase
    value = 'XYZ'

    assert_equal 'xyz', value.downcase
  end
end
