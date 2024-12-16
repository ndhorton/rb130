# Roman Numerals

=begin

P:

Write a class that takes a decimal integer in its constructor and
has a #to_roman method that returns a roman numeral string representation

We do not need to consider numbers greater than 3000.

Etc:

#to_roman
Given 2 -> II
etc
All tests show a decimal converted to a roman numeral string

163

going from left to right

1 -> I
+
6 -> VI
+
3 -> III

1000 => M
900  => CM
500  => D
400  => CD
100  => C
90   => XC
50   => L
40   => XL
10   => X
9    => IX
5    => V
4    => IV
1    => I 


place value

if we have 1000 (as opposed to 100 or 1) then we represent it differently
so rather than mapping decimal char -> roman chars, we should probably divide
off thousands, 900s, 500s hundreds, fifties etc

3965

3000 / 1000 == 3, so "M" * 3 pushed to string
965 / 900 == 1, so "CM" * 1
65  / 500 == 0
65 / 400 == 0
65 / 100 == 0
65 / 90 == 0
65 / 50 == 1, so "L" * 1
15 / 40 == 0
15 / 10 == 1
5 / 9 == 0
5 / 5 == 1
0 / 4 == 0
0 / 1 == 0

Approach:
we could have a hash with decimal keys => numeral values
iterate through keys
  if decimal / key > 0
    decimal, remainder = decimal divmod key
    push NUMERALS[key] * remainder to numeral_string

DS:

RomanNumeral
-initialize (int decimal) saves decimal integer
-to_roman -> string roman_numerals

A:

#to_roman
Set decimal := @decimal
Set result := empty string
Iterate over keys in NUMERALS hash sorted in descending order
  if decimal / key > 0
    remainder, decimal = decimal divmod key
    push NUMERALS[key] * remainder to result
Return result

=end

class RomanNumeral
  NUMERALS = {
    1000 => "M",
    900  => "CM",
    500  => "D",
    400  => "CD",
    100  => "C",
    90   => "XC",
    50   => "L",
    40   => "XL",
    10   => "X",
    9    => "IX",
    5    => "V",
    4    => "IV",
    1    => "I"
  }.freeze

  def initialize(decimal)
    @decimal = decimal
  end

  def to_roman
    decimal = @decimal
    result = ''
    significant_figures = NUMERALS.keys.sort { |a, b| b <=> a }

    significant_figures.each do |significant_figure|
      if decimal / significant_figure != 0
        remainder, decimal = decimal.divmod(significant_figure)
        result << NUMERALS[significant_figure] * remainder
      end
    end

    result
  end
end

        
