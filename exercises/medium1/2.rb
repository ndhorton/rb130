# Text Analyzer - Sandwich Code

=begin

P:

Write a TextAnalyzer#process method such that the method outputs:

3 paragraphs
15 lines
126 words

TextAnalyzer#process is given a filename of a text file to read text from.
We need to determine number of paragraphs, lines, and words.

Etc:

paragraphs end "\n\n" but there's also the first paragraph
lines are the count of "\n" characters but there's also the first line
words are separated by whitespace

DS:

A:

=end

class TextAnalyzer
  def process
    file = File.open("#{__dir__}/2_1.txt", "r")
    yield(file.read)
    file.close
  end
end

analyzer = TextAnalyzer.new
analyzer.process { |text| puts "#{text.scan("\n\n").size + 1} paragraphs" }
analyzer.process { |text| puts "#{text.count("\n") + 1} lines" }
analyzer.process { |text| puts "#{text.split.size} words" }

# LS solution
analyzer = TextAnalyzer.new
analyzer.process { |text| puts "#{text.split("\n\n").count} paragraphs" }
analyzer.process { |text| puts "#{text.split("\n").count} lines" }
analyzer.process { |text| puts "#{text.split.count} words" }