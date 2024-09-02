require 'minitest/autorun'
require_relative '../lib/xyzzy'

class XyzzyTest < Minitest::Test
  def test_the_answer_is_42
    xyzzy = Xyzzy.new
    assert(xyzzy.the_answer == 42, 'the_answer did not return 42')
  end

  def test_whats_up_returns_doc
    xyzzy = Xyzzy.new
    assert(xyzzy.whats_up == "Doc", 'whats_up did not return "Doc"')
  end
end
