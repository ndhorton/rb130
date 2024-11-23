# 5. Scrabble Score

=begin

P:

Write a program that, given a word, computes the Scrabble score for that
  word

Letter                      	Value
A, E, I, O, U, L, N, R, S, T 	1
D, G 	                        2
B, C, M, P 	                  3
F, H, V, W, Y 	              4
K 	                          5
J, X 	                        8
Q, Z 	                        10

Etc:

empty word scores zero
nil argument scores zero
whitespace scores zero (could extend this to non-letter character, no guidance)
  assume non-letter chars score 0
case insensitive for input

DS:
input: string
output: integer

DS for letters and values
use case-statement method

class Scrabble
::score
-takes string and returns score,
  could simple instantiate Scrabble object and call #score
#initialize - takes word and stores in instance variable
#score

A:
#score
Set letters := split word into letters
reduce each current_letter in letters starting accumulator at 0
  reduce function:
    accumulator + score_letter(current_letter)
return result
=end

# class Scrabble
#   attr_reader :word

#   def initialize(word)
#     @word = word.nil? ? '' : word
#   end

#   def self.score(word)
#     Scrabble.new(word).score
#   end

#   def score
#     word.upcase.chars.reduce(0) do |acc, current_letter|
#       acc + score_letter(current_letter)
#     end
#   end

#   private

#   def score_letter(letter)
#     case letter
#     when 'A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T' then 1
#     when 'D', 'G' 	                                      then 2
#     when 'B', 'C', 'M', 'P' 	                            then 3
#     when 'F', 'H', 'V', 'W', 'Y' 	                        then 4
#     when 'K'             	                                then 5
#     when 'J', 'X' 	                                      then 8
#     when 'Q', 'Z'       	                                then 10
#     else                                                       0
#     end
#   end
# end

# 25:15

# LS soltution
# class Scrabble
#   attr_reader :word

#   POINTS = {
#     'AEIOULNRST'=> 1,
#     'DG' => 2,
#     'BCMP' => 3,
#     'FHVWY' => 4,
#     'K' => 5,
#     'JX' => 8,
#     'QZ' => 10
#   }

#   def initialize(word)
#     @word = word ? word : ''
#   end

#   def score
#     letters = word.upcase.gsub(/[^A-Z]/, '').chars

#     total = 0
#     letters.each do |letter|
#       POINTS.each do |all_letters, point|
#         total += point if all_letters.include?(letter)
#       end
#     end
#     total
#   end

#   def self.score(word)
#     Scrabble.new(word).score
#   end
# end

# My #score_letter failed cyclomatic complexity, easy enough to convert to hash

class Scrabble
  LETTER_SCORES = {
    "AEIOULNRST" => 1,
    "DG" => 2,
    "BCMP" => 3,
    "FHVWY" => 4,
    "K" => 5,
    "JX" => 8,
    "QZ" => 10
  }.freeze
  private_constant :LETTER_SCORES

  attr_reader :word

  def initialize(word)
    @word = word.nil? ? '' : word
  end

  def self.score(word)
    Scrabble.new(word).score
  end

  def score
    word.upcase.chars.reduce(0) do |acc, current_letter|
      acc + score_letter(current_letter)
    end
  end

  private

  def score_letter(letter)
    LETTER_SCORES.each_pair do |letters, score|
      return score if letters.include?(letter)
    end
    0
  end
end
