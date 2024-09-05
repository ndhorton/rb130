# drop_while

=begin
P:

Write a method that takes an array and a block
Iterate through each element in the array passing element to the block
If any block iteration returns falsey
  add element to result array
  continue through the rest of the array adding elements to result array

Etc:

DS:

A:
Given an array, array, and a block
Set result := []
Set index := 0
Set falsey_return := false
Iterate while index < array size
  If yielding to block returns falsey
    falsey_return = true
  If falsey_return
    Push array[index] to result
  index = index + 1
Return result

=end

def drop_while(array)
  false_return = false
  index = 0
  result = []
  while index < array.size
    false_return = true unless yield(array[index])
    result << array[index] if false_return
    index += 1
  end
  result
end

def drop_while(array)
  index = 0
  result = []
  while index < array.size && yield(array[index])
    index += 1
  end
  array[index..-1]
end

p drop_while([1, 3, 5, 6]) { |value| value.odd? } == [6]
p drop_while([1, 3, 5, 6]) { |value| value.even? } == [1, 3, 5, 6]
p drop_while([1, 3, 5, 6]) { |value| true } == []
p drop_while([1, 3, 5, 6]) { |value| false } == [1, 3, 5, 6]
p drop_while([1, 3, 5, 6]) { |value| value < 5 } == [5, 6]
p drop_while([]) { |value| true } == []