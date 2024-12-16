# Octal

=begin

P:

Write a program that converts octal input string
to decimal integer output.

Do not use library methods for base conversion.

implicit:

We are only using positive numbers
An invalid octal string includes any chars other than 0-7
  An invalid octal string returns 0 from #to_decimal

Etc:

Octal class
constructor takes octal as string
#to_decimal outputs decimal as integer

place value

8^2 8^1 8^0
2   3   3

split string into chars
highest place value exponent is chars array size - 1
iterates down to 0

DS:

Array of chars

A:

constructor sets @octal_string to input

#octal_string returns @octal_string

#to_decimal
If octal_string matches /[^0-7]/ any char other than 0-7
  return 0

Set digits := split octal_string into chars
map digits through to_i ? is this using a library conversion? no
(Could simply use a hash)
Set power := digits size - 1
Set result := 0
Iterate over each digit in digits
  result = result + digit * (8 ** power)
  power = power - 1
return result
=end

# class Octal
#   def initialize(octal_string)
#     @octal_string = octal_string
#   end

#   def to_decimal
#     return 0 if octal_string =~ /[^0-7]/

#     digits = octal_string.chars.map { |char| DIGITS[char] }
#     power = digits.size - 1

#     digits.reduce(0) do |result, digit|
#       result += digit * (8**power)
#       power -= 1
#       result
#     end
#   end

#   private

#   DIGITS = {
#     '0' => 0,
#     '1' => 1,
#     '2' => 2,
#     '3' => 3,
#     '4' => 4,
#     '5' => 5,
#     '6' => 6,
#     '7' => 7
#   }.freeze
#   private_constant :DIGITS

#   attr_reader :octal_string
# end

# 19:23 passed Rubocop

# LS solution uses #to_i and #digits, which are allowed after all

class Octal
  attr_reader :number

  def initialize(str)
    @number = str
  end

  def to_decimal
    return 0 unless valid_octal?(number)

    arr_digits = number.to_i.digits

    new_number = 0
    arr_digits.each_with_index do |digit, exponent|
      new_number += digit * (8 ** exponent)
    end
    new_number
  end

  private

  def valid_octal?(num)
    num.chars.all? { |n| n =~ /[0-7]/ }
  end
end
