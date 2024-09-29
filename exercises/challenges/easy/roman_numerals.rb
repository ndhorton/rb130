# 3. Roman Numerals

=begin

P:

Write some code that converts modern decimal numbers into their Roman
number equivalent.

The largest number we need to convert is 3000.

So place value needs to be converted to the letters
e.g 1000 is M because the 1 appears at place value of 4
if it appeared at place value 1 it would be I

approaches:
find the number of digits
iterate from left to right over string representation of number
we get the place value index relative to the size of the string
  so if the size is 4
  index = 3 (last one)
  size - index = 1

10^3 10^2 10^1 10^0

9 3 2
9 * 10^2

if the current digit * 10^place_value_exponent is in [4, 9, 40, 90, 400, 900]
  put it through a hash that is like 4 => 'IV' etc
else
  3 - we're at place value exponent 1, so 3 * 10^1 = 30
when ""                  0 -> ''
when multiplied_value in 1..9 -> 'I' * digit
when " "                 10..90 -> 'X' * digit
when

1 -> I

Etc:

I II II IV
V VI VII VIII IX
X
L - 50
C - 100
D - 500
M - 1000

IV - 4
IX - 9
XL - 40
XC - 90
CD - 400
CM - 900

DS:

could store integer as string

subtraction_cases = {
  4 => 'IV',
  ...
  900 => 'CM'
}

class RomanNumeral
-initialize(number) -> store integer as decimal
-to_roman -> returns roman numeral representation as string

A:

#initialize
Given an integer, decimal
Set @decimal := decimal

digit_string = '1932'
places = 4
numeral = ''
index = 1, char = '1'
exponent = 4 - 1 = 3
current_value = 1 * 10^3 = 1000
Append 'M' to numeral

#to_roman
Set digit_string := convert decimal to string
Set places := size of digit_string
Set numeral := empty string
Iterate over each char in digit_string with index starting at 1
  Set exponent := places - index
  Set current_value := (convert char to integer) * 10^(exponent)
  if keys of SUBTRACTION_CASES includes current_value
    Append SUBTRACTION_CASES[current_value] to numeral
  else
    Append regular_case(current_value) to numeral
Return numeral

#regular_case (private)
Given an integer, value
if value == 0
  return ''
depeding on value:
when (1..9) then return 'I' * value
when (10..90) then return 'X' * (value / 10)
when (100..900) then return 'C' * (value / 100)
when (1000..9000)   then return 'M' * (value / 1000)

=end

# class RomanNumeral
#   attr_reader :digit_string

#   IRREGULAR_CASE = {
#     0 => '',
#     4 => 'IV',
#     9 => 'IX',
#     40 => 'XL',
#     90 => 'XC',
#     400 => 'CD',
#     900 => 'CM'
#   }

#   def initialize(decimal)
#     @digit_string = decimal.to_s
#   end

#   def to_roman
#     digit_string.each_char.with_index(1).map do |digit, index|
#       exponent = digit_string.size - index
#       current_value = (digit.to_i) * (10**exponent)
#       if IRREGULAR_CASE.keys.include?(current_value)
#         IRREGULAR_CASE[current_value]
#       else
#         regular_case(current_value)
#       end
#     end.join
#   end

#   private

#   def regular_case(value)
#     case value
#     when (1..3)       then ('I' * value)
#     when (5..8)       then ("V#{('I' * (value - 5))}")
#     when (10..30)     then ('X' * (value / 10))
#     when (50..80)     then ("L#{('X' * ((value - 50) / 10))}")
#     when (100..300)   then ('C' * (value / 100))
#     when (500..800)   then ("D#{('C' * ((value - 500) / 100))}")
#     else                   ('M' * (value / 1000))
#     end
#   end
# end

# 55 minutes
# The `RomanNumeral#regular_case` method is pushing the limit
# of Cyclomatic Complexity. Had to tinker to make it pass
# Rubcop. The LS solution is clearly better.

# LS solution/extra challenge

# class RomanNumeral
#   attr_reader :number

#   ROMAN_NUMERALS = {
#     "I" => 1,
#     "IV" => 4,
#     "V" => 5,
#     "IX" => 9,
#     "X" => 10,
#     "XL" => 40,
#     "L" => 50,
#     "XC" => 90,
#     "C" => 100,
#     "CD" => 400,
#     "D" => 500,
#     "CM" => 900,
#     "M" => 1000,
#   }

#   def initialize(number)
#     @number = number
#   end

#   def to_roman
#     ordered_numerals = ROMAN_NUMERALS.keys.sort do |a, b|
#       ROMAN_NUMERALS[b] <=> ROMAN_NUMERALS[a]
#     end
#     roman_version = ''
#     to_convert = number

#     ordered_numerals.each do |key|
#       value = ROMAN_NUMERALS[key]
#       multiplier, remainder = to_convert.divmod(value)
#       if multiplier > 0
#         roman_version += (key * multiplier)
#       end
#       to_convert = remainder
#     end
#     roman_version
#   end
# end

class RomanNumeral
  NUMERAL_VALUES = {
    'I' => 1,
    'IV' => 4,
    'V' => 5,
    'IX' => 9,
    'X' => 10,
    'XL' => 40,
    'L' => 50,
    'XC' => 90,
    'C' => 100,
    'CD' => 400,
    'D' => 500,
    'CM' => 900,
    'M' => 1000
  }.freeze
  private_constant :NUMERAL_VALUES

  attr_reader :decimal

  def initialize(decimal)
    @decimal = decimal
  end

  def to_roman
    # set number = decimal
    # set result = empty string
    # iterate through each numeral in descending_numerals
    #   set quotient, remainder =  number divmod NUMERAL_VALUES[numeral]
    #   if quotient is not 0
    #     number = remainder
    #     append numeral * quotient to result
    # return result

    remaining_number = decimal
    descending_numerals.each_with_object('') do |numeral, result|
      quotient, remainder = remaining_number.divmod(NUMERAL_VALUES[numeral])
      next if quotient.zero?
      remaining_number = remainder
      result << (numeral * quotient)
    end
  end

  private

  def descending_numerals
    NUMERAL_VALUES.keys.sort do |a, b|
      NUMERAL_VALUES[b] <=> NUMERAL_VALUES[a]
    end
  end
end
