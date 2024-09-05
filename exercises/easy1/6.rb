# Iterators: True for Any?

=begin

P:

  Write an `any?` method that takes an array argument and a block.
  It should return `true` if the block returns `true` for any element in array.
  Otherwise it returns false. The method should stop processing elements as
  soon as the block returns `true`. An empty array arg returns `false`
  immediately.

Etc:

DS:

A:
Given an array, array, and a block
Iterate through each element in array
  If yielding element to the block returns true
    Return true
Return false
=end

def any?(array)
  array.each { |element| return true if yield(element) == true }
  false
end

# LS solution (doesn't follow spec, returns true if block yield returns truthy)
# def any?(collection)
#   collection.each { |item| return true if yield(item) }
#   false
# end

p any?([1, 3, 5, 6]) { |value| value.even? } == true
p any?([1, 3, 5, 7]) { |value| value.even? } == false
p any?([2, 4, 6, 8]) { |value| value.odd? } == false
p any?([1, 3, 5, 7]) { |value| value % 5 == 0 } == true
p any?([1, 3, 5, 7]) { |value| true } == true
p any?([1, 3, 5, 7]) { |value| false } == false
p any?([]) { |value| true } == false

p any?({ a: 1, b: 2, c: 3}) { |key, value| value > 2 }
p any?(Set.new([1, 2, 3])) { |member| member == 3 }
