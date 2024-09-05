# Empty Object Assertions

require 'minitest/autorun'

class EmptyTest < Minitest::Test
  def test_if_empty
    list = []

    assert_empty list
  end
end
