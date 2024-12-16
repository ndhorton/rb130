require 'minitest/autorun'

require_relative 'text'

class TextTest < Minitest::Test
  def setup
    @file = File.open("#{__dir__}/sample_text.txt", "r")
  end

  def test_swap
    text = Text.new(@file.read)
    swapped_text = File.read("#{__dir__}/sample_text_swapped.txt")

    assert_equal swapped_text, text.swap('a', 'e')
  end

  def test_word_count
    text = Text.new(@file.read)

    assert_equal 72, text.word_count
  end

  def teardown
    @file.close
    puts "File has been closed: #{@file.closed?}"
  end
end
