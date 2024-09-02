# Divisors

=begin

P:
  Write a method that returns a list of all the divisors of the positive
  integer passed in as an argument. The return value can be in any
  sequence you wish.

Etc:

DS:

A:
Given a positive integer, number
Set factors := empty Set
Set counter := 1
Iterate while counter * counter <= number
  If number % counter == 0
    Push counter to factors
    Push (numer / counter) to factors
Set results := convert factors to array
Return results

=end

def divisors(number)
  results = Set.new
  counter = 1
  while (counter * counter) <= number
    if number % counter == 0
      results << counter
      results << number / counter
    end
    counter += 1
  end
  results.to_a.sort
end

# LS brute force solution

# def divisors(number)
#   1.upto(number).select do |candidate|
#     number % candidate == 0
#   end
# end

p divisors(1) == [1]
p divisors(7) == [1, 7]
p divisors(12) == [1, 2, 3, 4, 6, 12]
p divisors(98) == [1, 2, 7, 14, 49, 98]
p divisors(99400891) == [1, 9967, 9973, 99400891] # may take a minute

p divisors(999962000357) == [1, 999979, 999983, 999962000357]