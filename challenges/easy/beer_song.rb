# 9. Beer Song

=begin

P:

Write a program that can generate the lyrics of the 99 Bottles of Beer song.

Includes one and zero beers
- 0 is represented by 'No more' and has its own second line
- 1 needs its own verse text really

Etc:

DS:
input: integers
output: string

class BeerSong
::verse(int)
::verses(list of ints)
::lyrics -> returns lyrics for whole song in descending order

A:

#verse
Given an integer, number_of_bottles
if number_of_bottles > 1
  standard_verse(number_of_bottles)
elsif number_of_bottles == 1
  verse1()
elsif number_of_bottles == 0
  verse0()

#standard_verse(number_of_bottles)
return "#{number_of_bottles} bottles of beer on the wall, #{number_of_bottles}"
  " bottles of beer\n" +
"Take one down and pass it around, #{number_of_bottles - 1} bottles of beer"
" on the wall."

#verse1
verbatim

#verse0
verbatim

#verses
Given an argument list -> array, verse_numbers
Set result := empty string
Iterate for each number in verse_numbers
  result = result + "\n" + verse(number)
Return result

#lyrics
Set result := empty_string
Fold number 0 through 99, starting with empty string, result
  verse(number) + "\n" + result

=end

class BeerSong
  def self.verse(number)
    first_line(number) + second_line(number)
  end

  def self.verses(start, finish)
    result = ''
    start.downto(finish) do |number|
      result += "#{verse(number)}\n"
    end
    result.chomp
  end

  def self.lyrics
    verses(99, 0)
  end

  class << self
    private

    def first_line(number)
      bottles = handle_singular(number)
      number = 'no more' if number.zero?
      "#{number} #{bottles} of beer on the wall, " \
      "#{number} #{bottles} of beer.\n".capitalize
    end

    def second_line(number)
      second_line_first_half(number) + second_line_second_half(number)
    end

    def second_line_first_half(number)
      if number.zero?
        'Go to the store and buy some more, '
      else
        "Take #{one_or_it(number)} down and pass it around, "
      end
    end

    def second_line_second_half(number)
      new_number = decrement_or_restart(number)
      "#{new_number} #{handle_singular(new_number)} of beer on the wall.\n"
    end

    def decrement_or_restart(number)
      case number
      when 0 then 99
      when 1 then 'no more'
      else
        number - 1
      end
    end

    def handle_singular(number)
      number == 1 ? 'bottle' : 'bottles'
    end

    def one_or_it(number)
      number == 1 ? 'it' : 'one'
    end
  end
end

# 1:06:42

=begin

What went wrong:
Did not read the test cases for #verses in enough detail. Not realizing
what the arguments meant cost me at least 25 minutes.

from the LS solution pedac: "verses accepts two number arguments. The first
argument is the number verse on which to start, and the second argument
represents the number verse on which to end. The method should return a string
representing all verses in this range (inclusive)."

Maybe need to understand HEREDOCs better to understand how <<- deals with the
final newline (which cost me ages of time). Compounding this was the
difficulty in reading the diffs for newlines (and diffs generally).

Work all the String exercises on Exercism for practice reading minitest diffs
You could also practice invalidating the output for the BeerSong tests with
rogue newlines and seeing how it affects the diff output.
=end

# LS solution
# funnily enough, this uses my initial strategy of having seperate methods
# for verses 0, 1, 2, 3 or more
# I think the use of Array/#join for string-building is probably more typical
# than building a string as a String and would have saved me the diff pains
# class Verse
#   attr_reader :bottles

#   def initialize(bottles)
#     @bottles = bottles
#   end

#   def single_verse
#     case bottles
#     when 0 then zero_bottle_verse
#     when 1 then single_bottle_verse
#     when 2 then two_bottle_verse
#     else
#       default_verse
#     end
#   end

#   private

#   def default_verse
#     "#{bottles} bottles of beer on the wall, #{bottles} " \
#       "bottles of beer.\nTake one down and pass it around, " \
#       "#{bottles - 1} bottles of beer on the wall.\n"
#   end

#   def two_bottle_verse
#     "2 bottles of beer on the wall, 2 bottles of beer.\n" \
#       "Take one down and pass it around, 1 bottle of beer " \
#       "on the wall.\n"
#   end

#   def single_bottle_verse
#     "1 bottle of beer on the wall, 1 bottle of beer.\n" \
#       "Take it down and pass it around, no more bottles of beer " \
#       "on the wall.\n"
#   end

#   def zero_bottle_verse
#     "No more bottles of beer on the wall, no more bottles " \
#       "of beer.\nGo to the store and buy some more, 99 bottles " \
#       "of beer on the wall.\n"
#   end
# end

# class BeerSong
#   def self.verse(number)
#     Verse.new(number).single_verse
#   end

#   def self.verses(start, stop)
#     current_verse = start
#     result = []

#     while current_verse >= stop
#       result << verse(current_verse).to_s # I guess interpolation makes clear
#       current_verse -= 1                  # we are collecting String objects
#     end

#     result.join("\n")
#   end

#   def self.lyrics
#     verses(99, 0)
#   end
# end
