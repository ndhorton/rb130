# Included Object Assertions

require 'minitest/autorun'

class IncludeTest < Minitest::Test
  def test_if_object_included_in_array
    list = %w(abc xyz)

    assert_includes list, 'xyz'
  end
end
