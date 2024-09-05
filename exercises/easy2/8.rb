# max_by

=begin

P: Write a max_by method that takes an array and a block
   Yield each element to the block
   Return the element whose block returned the greatest value

Etc:

max_by([1, 5, 3]) { |value| value + 2 }

iteration value block_return
    1       1       3
    2       5       7
    3       3       5

7 is maximum so return 5

DS:

A:
max method
Given an array, array
Set maximum := first element of array
Iterate through the remaining elements
  If element >= maximum
    maximum = element
Return maximum

max_by method
Given an array, array, and a block
Set sort_keys := empty hash
Iterate through each element in array
  Insert yield(element) => element in sort_keys
Set maximum_key := max(only key part of sort_keys)
Return sort_keys[maximum_key]

One method approach:

max_by:
Given an array and a block
Set maximum_element := first element in array
Set maximum_yield := yield first element
Iterate through each remaining element in array
  current_yield = yield(element)
  if maximum_yield < current_yield
    maximum_yield = current_yield
    maximum_element = element
Return maximum_element
=end

def max(array)
  maximum = array.first
  (1...array.size).each do |index|
    element = array[index]
    maximum = element if element >= maximum
  end
  maximum
end

def max_by(array)
  sort_keys = {}
  array.each { |element| sort_keys[yield(element)] = element }
  maximum_key = max(sort_keys.keys)
  sort_keys[maximum_key]
end

def max_by(array)
  return if array.empty?
  
  max_element = array.first
  max_key = yield(max_element)
  
  (1...array.size).each do |index|
    current_element = array[index]
    current_key = yield(current_element)
    if max_key <= current_key
      max_key = current_key
      max_element = current_element
    end
  end
  
  max_element
end

# LS solution
# def max_by(array)
#   return nil if array.empty?

#   max_element = array.first
#   largest = yield(max_element)

#   array[1..-1].each do |item|
#     yielded_value = yield(item)
#     if largest < yielded_value
#       largest = yielded_value
#       max_element = item
#     end
#   end

#   max_element
# end

p max_by([1, 5, 3]) { |value| value + 2 } == 5
p max_by([1, 5, 3]) { |value| 9 - value } == 1
p max_by([1, 5, 3]) { |value| (96 - value).chr } == 1
p max_by([[1, 2], [3, 4, 5], [6]]) { |value| value.size } == [3, 4, 5]
p max_by([-7]) { |value| value * 3 } == -7
p max_by([]) { |value| value + 5 } == nil
