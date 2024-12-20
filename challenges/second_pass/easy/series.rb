# Series

=begin

P:

Write a program that will take a string of digits and
return all the possible consecutive number series of a
specified length in that string.

If the length is greater than the length of the digit string,
throw an error

Etc:

01234
-> 3
012
123
234

raise ArgumentError if #slices given a length greater
than size of @digits

DS:

class Series
constructor takes digit string

#slices (int length)
-> array of arrays of integers

A:

#initialize (string digits)
@digits = digits

#slices
Given an integer, length
if length > @digits.length
  raise ArgumentError

Set result := empty array
split @digits into chars
map through integer conversion
iterate over subarray of each consecutive length digits
push subarray to result

return result
=end

class Series
  attr_reader :digits

  def initialize(digits)
    @digits = digits.freeze
  end

  def slices(len)
    raise ArgumentError if len > digits.length

    digits.chars.map(&:to_i).each_cons(len).reduce([]) do |result, subarray|
      result << subarray
    end
  end
end

# 12:35 passed rubocop

# LS solution, same but we only need #to_a called on the
# result of #each_cons. Obvious now
