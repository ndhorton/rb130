require 'minitest/autorun'

class TestTest < Minitest::Test
  def test_some_operators
    assert_operator [], :<<, 5
  end
end