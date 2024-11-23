# 10. Series

=begin

P:

Write a program that will take a string of digits and return all the
possible consecutive number series of a specified length in that string.

Etc:

Raise ArgumentError if argument to #slices is > length of @digits
Otherwise, return array of arrays

37103 slices arg: 2
-> [[3, 7], [7, 1], [1, 0], [0, 3]]

DS:
input: String of digits
output: Array of arrays of integers

class Series
#initialize(String digits) - saves string to @digits
#slices(Integer slice_length)

A:

#slices
Given an integer, slice_length
If slice_length > length of @digits
  Raise ArgumentError

Set result := empty array
Split @digits into chars and iterate for each consecutive slice of slice_length
  map slice through Integer conversion
  push slice to result
Return result

=end

class Series
  attr_reader :digits

  def initialize(digits)
    @digits = digits
  end

  def slices(slice_length)
    raise ArgumentError if slice_length > digits.length

    numeric_digits = digits.each_char.map(&:to_i)
    numeric_digits.each_cons(slice_length).to_a
  end
end

# 13:22

# LS solution
# class Series
#   attr_accessor :number_string

#   def initialize(str)
#     @number_string = str
#   end

#   def slices(length)
#     raise ArgumentError.new if length > number_string.size

#     number_string.chars.map(&:to_i).each_cons(length).to_a
#   end
# end
