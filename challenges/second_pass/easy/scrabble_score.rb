# Scrabble Scores

=begin

P:

Write a program that, given a word, computes the scrabble score
for that word.

Tile values:

A, E, I, O, U, L, N, R, S, T 	1
D, G 	2
B, C, M, P 	3
F, H, V, W, Y 	4
K 	5
J, X 	8
Q, Z 	10

Etc:

Empty word scores zero
Whitespace scores zero
`nil` passed as argument scores zero
Should be case insensitive

DS:

class Scrabble
-constructor takes word and saves it
-#score -> int score

A:
#initialize
Given a string, word
Set @word to uppercase version of word

#word
return @word

#score
Set result := 0
Iterate over each char in word
  result = result + score_letter(char)
Return result

#score_letter(char) private
Use table to return appropriate tile score

=end

class Scrabble
  TILES = {
    "AEIOULNRST" => 1,
    "DG" => 2,
    "BCMP" => 3,
    "FHVWY" => 4,
    "K" => 5,
    "JX" => 8,
    "QZ" => 10
  }.freeze
  private_constant :TILES

  def initialize(word)
    @word = word ? word.upcase.gsub(/[^A-Z]/, '') : ''
  end

  def score
    word.each_char.sum { |char| tile_score(char) }
  end

  def self.score(word)
    Scrabble.new(word).score
  end

  private

  attr_reader :word

  def tile_score(char)
    TILES.each_key do |letter_group|
      return TILES[letter_group] if letter_group.include?(char)
    end
    0
  end
end

# 15:00

# After Rubcop refactoring: 22:39
