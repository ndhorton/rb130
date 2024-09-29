# 8. Sum of Multiples

=begin

P:

Write a program that, given a natural number and a set of one or more other
numbers, can find the sum of all the multiples of the numbers in the set
that are less than the first number.

If the set of numbers is not given, use a default set of 3 and 5

We are only using natural numbers for both set_of_factors and endpoint

Etc:

If we list all the natural numbers up to, but not including, 20
  that are multiples of either 3 and 5, we get
  { 3, 5, 6, 9, 10, 12, 15, 18 }
  and the sum of these numbers is 78, which is what we return

approach:
We could iterate through each number from 1
For each number
  Iterate through list of factors
  if number any of the factors divides number with zero remainder
  add number to sum

For instance,
1 can't be divided by 3 or 5 without remainder
2 neither
3 can be divided by 3 without remainder so add to sum
and so on.

DS:

class SumOfMultiples
::to(int) - uses default set {3, 5} and finds all multiples less than int
::new(set given as list of integers)
#to(int) - uses set given to constructor and finds all multiples less than int

A:

#to
Given a positive integer, endpoint
Set sum := 0
Iterate for current_number from 1 upto not including endpoint
  if any factor in set_of_factors divides current_number without remainder
    sum = sum + current_number
Return sum
=end

# class SumOfMultiples
#   def initialize(*factors)
#     @factors = factors
#   end

#   def to(endpoint)
#     (1...endpoint).reduce(0) do |sum, current_number|
#       if @factors.any? { |factor| current_number % factor == 0 }
#         next sum + current_number
#       end
#       sum
#     end
#   end

#   def self.to(endpoint)
#     SumOfMultiples.new(3, 5).to(endpoint)
#   end
# end

# 20:20

=begin

afterthoughts:

another approach would be to iterate through the factors
for each factor, sum all the multiples less than endpoint

#to
Given a positive integer, endpoint
Set sum := 0
Iterate for each factor in @factors
  Set current_number := factor
  Iterate while current_number < endpoint
    sum = sum + current_number
    current_number = current_number + factor
Return sum

This approach does not work, since it includes certain numbers in the sum
that are divisible by multiple factors multiple times.

So the only way I can think to deal with this would be to collect numbers in a
Set/Hash so that only unique numbers get added, then sum them.

#to
Given a positive integer, endpoint
Set result_set := empty hash
Iterate for each factor in @factors
  Set current_number := factor
  Iterate while current_number < endpoint
    result_set[current_number] = true
    current_number = current_number + factor
Return sum of the keys of result_set
=end

class SumOfMultiples
  def initialize(*factors)
    @factors = factors.empty? ? [3, 5] : factors
  end

  def to(endpoint)
    result_set = {}

    @factors.each do |factor|
      current_number = factor
      while current_number < endpoint
        result_set[current_number] = true
        current_number += factor
      end
    end

    result_set.keys.sum
  end

  def self.to(endpoint)
    SumOfMultiples.new.to(endpoint)
  end
end

# LS solution

# class SumOfMultiples
#   attr_reader :multiples

#   def self.to(num)
#     SumOfMultiples.new().to(num)
#   end

#   def initialize(*multiples)
#     @multiples = (multiples.size > 0) ? multiples : [3, 5]
#   end

#   def to(num)
#     (1...num).select do |current_num|
#       any_multiple?(current_num)
#     end.sum
#   end

#   private

#   def any_multiple?(num)
#     multiples.any? do |multiple|
#       (num % multiple).zero?
#     end
#   end
# end
