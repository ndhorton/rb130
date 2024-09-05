# Same Object Assertions

require 'minitest/autorun'

class List
  def process
    self
  end
end

class SameTest < Minitest::Test
  def test_if_process_returns_original_object
    list = List.new

    assert_same list, list.process
  end
end
