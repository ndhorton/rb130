# Sum of Multiples

=begin

P:

Write a program that, given a natural number and a set of
one or more other numbers, can find the sum of all the multiples
of the numbers in the set that are less than the first number.

If the set of numbers is not given, use 3 and 5

Do not count the same number twice in the sum,
  so for 3 and 5, they share the multiple 15
  only count 15 once

Etc:

number = 20
set = [3, 5]

3 6 9 12 15 18

5 10 (15 already included in the 3 multiples)

add together all the above multiples

=> 78

So we want a unique set of all multiples to add

Could use Set or Hash, or simply Array#uniq

Prepare for situation where number is lower than
any of the set of factors => 0

DS:

Could use Set or Hash, or simply Array#uniq

class SumOfMultiples
::to (int number) makes use of instance and instance method
#initialize (array factors)
#to (int number)

A:
::to
given an integer, number
instantiate a SumOfMultiples passing 3, 5
return sum_of_mulitples#to(number)

#initialize
Given a variable list of integers, factors
Set @factors = factors

#to
Given an integer, number
Set multiples = empty hash
Iterate each factor in @factors
  Set multiple := factor
  Iterate until multiple >= number
    multiples[multiple] = true
    multiple = multiple + factor
Sum the keys of multiples and return sum
=end

class SumOfMultiples
  attr_reader :factors

  def initialize(*factors)
    @factors = factors.empty? ? [3, 5] : factors
    @factors.freeze
  end

  def to(number)
    multiples = {}

    factors.each do |factor|
      multiple = factor

      while multiple < number
        multiples[multiple] = true
        multiple += factor
      end

    end
    multiples.keys.sum
  end

  def self.to(number)
    SumOfMultiples.new.to(number)
  end
end

# 20:55 passed rubocop
