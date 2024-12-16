# Perfect Numbers

=begin

P:

Write a program that can tell whether a number is perfect,
abundant or deficient

Aliquot sum: sum of positive divisors excluding number itself

Perfect - Aliquot sum == number
Abundant - Aliquot sum > number
Deficient - Aliquot sum < number

Etc:

PerfectNumber class or module
PerfectNumber::classify returns 'perfect' etc or
raises StandardError if number is negative

DS:

A:

#aliquot_sum
Given an integer, number
Set result := 1
Iterate for divisor from 2 to square root of number
  if number % divisor == 0
    result = result + number / divisor + divisor
Return result

=end

class PerfectNumber
  class << self
    def classify(number)
      raise StandardError if number < 1

      case aliquot_sum(number) <=> number
      when 0  then 'perfect'
      when 1  then 'abundant'
      when -1 then 'deficient'
      end
    end

    private

    def aliquot_sum(number)
      result = 1
      2.upto(Math.sqrt(number).to_i) do |divisor|
        if number % divisor == 0
          result += divisor + (number / divisor)
        end
      end
      result
    end
  end
end

# 12:15 - passed Rubocop

# 15:33 - refactor AND forgot the exception case for
# non-positive numbers. The test passed because calling
# Math::sqrt with a non-positive number raised a
# Math::DomainError, which is a subclass of StandardError.
# Probably not what they want though...
