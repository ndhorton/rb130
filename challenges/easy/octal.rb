# 7. Octal

=begin

P:

Implement octal to decimal conversion.
Given an octal input string.
If input string not valid octal, it should be treated as 0
The only valid octal digits are 0 through 7

Cannot use to_s, to_i, etc.

Etc:

octal: 123
array: [1, 2, 3]
array size: 3
max exponent = 3-1 = 2

1 * 8^(max exponent) + 2 * 8^(max exponent - 1) + 1 3 8^(max exponent - 1 - 1)

One approach might be simply to reverse the digits and start counting from 0.
Since we are only dealing with addition and multiplication the result is the
same.

implicit: We won't be dealing with negative input.

DS:

Octal class
-#initialize(string) saves string as state
-#to_decimal - returns decimal Integer version of saved octal string

A:
#initialize
Given an octal string, octal_string
Set @octal_string = octal_string

#to_decimal
return 0 unless valid_octal?
Set digits := reverse octal_string
              split into characters
              map each character to Integer equivalent
Set result := 0
Iterate over each digit in digits with index
  result = result + digit * 8^index
return result

#valid_octal? (private)
if @octal_string matches /\A[0-7]+\z/
  return true
else
  return false
=end

class Octal
  def initialize(octal_string)
    @string = octal_string
  end

  def to_decimal
    return 0 unless string_valid?

    result = 0
    @string.to_i.digits.each_with_index do |digit, index|
      result += digit * (8**index)
    end

    result
  end

  private

  def string_valid?
    @string.match?(/\A[0-7]+\z/)
  end
end

# 25:09

# class Octal
#   attr_reader :number

#   def initialize(str)
#     @number = str
#   end

#   def to_decimal
#     return 0 unless valid_octal?(number)

#     arr_digits = number.to_i.digits

#     new_number = 0
#     arr_digits.each_with_index do |num, exponent|
#       new_number += (num * (8**exponent))
#     end

#     new_number
#   end

#   private

#   def valid_octal?(num)
#     num.chars.all? { |n| n =~ /[0-7]/ }
#   end
# end
