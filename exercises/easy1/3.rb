# Find Missing Numbers

=begin

P: Write a method that takes a sorted array of integers as an argument,
and returns an array that includes all of the missing integers (in order)
between the first and last elements of the argument.

Etc:

[-3, -2, 1, 5] : first -3, last: 5 -> (-3..5)
[-3, -2, -1, 0, 1, 2, 3, 4, 5] - [-3, -2, 1, 5]
= [-1, 0, 2, 3, 4]

-3, -2
since -2 is 1 higher than -3 we continue

-2, 1
since 1 is more than 1 higher than -2
  iterate from (-2 + 1) up to exclusive 1, current_number
    push current_number to results

Works for all other examples

DS:

A:
Given an array, numbers
Set full_range := Instantiate range from numbers first to numbers last
Return numbers - full_range

Using `each_cons`:
Given an array, numbers
Set results := empty array
Iterate over each consecutive pair of numbers, a and b
  if b - a == 1
    continue to next iteration
  else
    Set missing_range := generate numbers from (a+1) to (b-1) inclusive
    results = results + missing_range
return results
=end

def missing(numbers)
  return [] if numbers.empty?

  full_range = (numbers.first..numbers.last).to_a
  full_range - numbers
end

def missing(numbers)
  results = []
  numbers.each_cons(2) do |first, second|
    next if second - 1 == 1
    results.concat(((first + 1)..(second - 1)).to_a)
  end
  results
end

p missing([-3, -2, 1, 5]) == [-1, 0, 2, 3, 4]
p missing([1, 2, 3, 4]) == []
p missing([1, 5]) == [2, 3, 4]
p missing([6]) == []