# Nil Assertions

require 'minitest/autorun'

class NilTest < Minitest::Test
  def test_if_nil
    value = nil

    assert_nil value
  end
end