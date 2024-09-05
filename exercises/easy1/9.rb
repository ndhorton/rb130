# Iterators: True for One?

=begin

P:

Write a method called one? that takes an array and a block.
one? calls the block for each element in the array.
If the block returns truthy for one elment exactly then one? return true,
false otherwise.
one? should return false as soon as the block returns true a second time

Etc:

DS:

A:

=end

def one?(collection)
  once = false
  collection.each do |element|
    if yield(element)
      return false if once
      once = true
    end
  end
  once
end

# LS solution
def one?(collection)
  seen_one = false
  collection.each do |element|
    next unless yield(element)
    return false if seen_one
    seen_one = true
  end
  seen_one
end

p one?([1, 3, 5, 6]) { |value| value.even? }    == true
p one?([1, 3, 5, 7]) { |value| value.odd? }     == false
p one?([2, 4, 6, 8]) { |value| value.even? }    == false
p one?([1, 3, 5, 7]) { |value| value % 5 == 0 } == true
p one?([1, 3, 5, 7]) { |value| true }           == false
p one?([1, 3, 5, 7]) { |value| false }          == false
p one?([]) { |value| true }                     == false