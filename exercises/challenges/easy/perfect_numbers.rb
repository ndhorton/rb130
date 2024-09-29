# 6. Perfect Number

=begin

notes/questions:
* what is the Aliquot sum for 1? It is 0

approach:
find the aliquot sum
  find the divisors of a number
  add them up

Then just simple if/elsif/else

P:

Write a program that can tell whether a number is perfect, abundant, or
  deficient.

Perfect: the Aliquot sum is equal to the number
Deficient: the Aliquot sum is less than the number
Abundant: the Aliquot sum is greater than the number

Aliquot sum is the sum of the positive divisors of an integer excluding the
integer itself

Etc:

negative numbers as arguments should raise StandardError

DS:

module PerfectNumber
- ::classify
  input: integer
  output: string

A:

#classify
Given an integer, number
if number < 0
  raise StandardError

if aliquot_sum(number) == number
  return 'perfect'
else if aliquot_sum(number) < number
  return 'deficient'
else
  return 'abundant'

#aliquot_sum
Given an integer, number
Return 0 if number == 1
counter = 2
divisors = [1]
Iterate while counter * counter <= number
  if number % counter == 0
    Append counter to divisors
    Append number / counter to divisors
  increment counter
Return sum of elements in divisors
=end

class PerfectNumber
  class << self
    def classify(number)
      raise StandardError, 'must be positive integer' if number <= 0

      sum = aliquot_sum(number)
      if sum == number
        'perfect'
      elsif sum < number
        'deficient'
      else
        'abundant'
      end
    end

    private

    def aliquot_sum(number)
      return 0 if number == 1

      sum = 1
      counter = 2
      while counter * counter <= number
        if number % counter == 0
          sum += counter + (number / counter)
        end
        counter += 1
      end

      sum
    end
  end
end

# 26:52

# class PerfectNumber
#   def self.classify(number)
#     raise StandardError.new if number < 1
#     sum = sum_of_factors(number)

#     if sum == number
#       'perfect'
#     elsif sum > number
#       'abundant'
#     else
#       'deficient'
#     end
#   end

#   class << self
#     private

#     def sum_of_factors(number)
#       (1...number).select do |possible_divisor|
#         number % possible_divisor == 0
#       end.sum
#     end
#   end
# end
