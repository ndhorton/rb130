# Iternal vs External Iterators

=begin

P:
  Write an Enumerator object that encapsulates an iteration over
  the infinite sequence of factorials from factorial(0) onward.

Etc:

Test it out by printing the first 7 members of the sequence starting
with factorial(0) using an 'External Iterator'.
Once you have done so, see what happens if you print 3 more factorials.
Reset the Enumerator (using the #rewind method)
Print 7 more factorials

=end

# factorial = Enumerator.new do |yielder|
#   n = 0
#   yielder << 1
#   n += 1
#   loop do
#     yielder << (1..n).reduce(:*)
#     n += 1
#   end
# end

# 7.times { |i| puts "#{i}: #{factorial.next}" }

# puts factorial.next
# puts factorial.next
# puts factorial.next

# factorial.rewind

# 7.times { |i| puts "#{i}: #{factorial.next}" }


# LS solution
factorial = Enumerator.new do |yielder|
  accumulator = 1
  number = 0
  loop do
    accumulator = number.zero? ? 1 : accumulator * number
    yielder << accumulator
    number += 1
  end
end

# factorial = Enumerator.new do |yielder|
#   accumulator = 1
#   number = 0
#   yielder << accumulator
#   number += 1
#   loop do
#     accumulator = number * accumulator
#     yielder << accumulator
#     number += 1
#   end
# end

# External iterators
6.times { |number| puts "#{number}! == #{factorial.next}" }
puts "=========================="
6.times { |number| puts "#{number}! == #{factorial.next}" } # Note the incorrect output
puts "=========================="
factorial.rewind # restart sequence
6.times { |number| puts "#{number}! == #{factorial.next}" } # This time output makes sense again
puts "=========================="

# Internal iterators

factorial.each_with_index do |value, number|
  puts "#{number}! == #{value}"
  break if number >= 5
end
