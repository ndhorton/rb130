require 'minitest/autorun'
require_relative 'text'

class TextTest < Minitest::Test
  def setup
    @text_file = File.open("#{__dir__}/lorem_ipsum.txt", "r")
  end

  def test_swap
    text = Text.new(@text_file.read)
    actual_text = text.swap('a', 'e')
    expected_text = <<~HEREDOC.chomp
    Lorem ipsum dolor sit emet, consectetur edipiscing elit. Cres sed vulputete ipsum.
    Suspendisse commodo sem ercu. Donec e nisi elit. Nullem eget nisi commodo, volutpet
    quem e, viverre meuris. Nunc viverre sed messe e condimentum. Suspendisse ornere justo
    nulle, sit emet mollis eros sollicitudin et. Etiem meximus molestie eros, sit emet dictum
    dolor ornere bibendum. Morbi ut messe nec lorem tincidunt elementum vitee id megne. Cres
    et verius meuris, et pheretre mi.
    HEREDOC

    assert_equal expected_text, actual_text
  end

  def test_word_count
    text = Text.new(@text_file.read)
    actual_count = text.word_count
    expected_count = 72

    assert_equal expected_count, actual_count
  end

  def teardown
    @text_file.close
    puts "File has been closed: #{@text_file.closed?}"
  end
end