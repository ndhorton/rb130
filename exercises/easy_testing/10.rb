# Refutations

require 'minitest/autorun'

class RefuteTest < Minitest::Test
  def test_if_not_included
    list = ['abc']

    refute_includes list, 'xyz'
  end
end
