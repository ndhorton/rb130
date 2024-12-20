# Beer Song

=begin

P:

Write a program that can generate the lyrics of the 99 Bottles
of Beer song.

Etc:

It often helps to go to the end of the tests first to note
edge cases, as here especially.

number can be 0-99, where all but 0 are simply the number
0 needs to be mapped to 'No more'

So the getter should return @number if @number != 0
  and 'No more' otherwise
This takes case of the 0 verse, also the verse before

So the 0 verse needs 'No more', it also needs
  'Go to the store and buy some more'
  then we need to reset number to 99

The 1 verse needs 'bottle' instead of 'bottles',
  so we need a simple #bottles method that checks @number
  also "Take it down" instead of "Take one down"

class/module BeerSong (no state)
::verse (int verse_number) -> just that verse
::verses (int from, int to) -> verses in [from, to]
::lyrics

DS:

A:

=end

class BeerSong
  class << self

    def lyrics
      verses(99, 0)
    end

    def verses(start, finish)
      result = ''
      start.downto(finish) do |number|
        result << verse(number)
        result << "\n"
      end
      result.chomp
    end

    def verse(number)
      result = ''
      result << "#{zero_or_number(number).to_s.capitalize} " \
        "#{bottles(number)} of beer on the wall, " \
        "#{zero_or_number(number)} #{bottles(number)} of beer.\n" \
        "#{down_or_more(number)}, "
      number = decrement(number)
      result << "#{zero_or_number(number)} #{bottles(number)} " \
        "of beer on the wall.\n"
      result
    end

    private

    def decrement(number)
      number > 0 ? number - 1 : 99
    end

    def down_or_more(number)
      case number
      when 0 then "Go to the store and buy some more"
      when 1 then "Take it down and pass it around"
      else        "Take one down and pass it around"
      end
    end

    def bottles(number)
      number == 1 ? 'bottle' : 'bottles'
    end

    def zero_or_number(number)
      number.zero? ? 'no more' : number
    end
  end

end

# 37:41 passes rubocop


