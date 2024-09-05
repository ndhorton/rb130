# Zipper

=begin

P: Write a zip method where caller is first arg, arg is second arg
Assume arrays will be equal length

Etc:

arr1 = [1, 2, 3]
arr2 = [4, 5, 6]

Let i = 0
[arr1[i], arr2[i]]

DS:
new array of arrays

A:
Given two arrays, arr1, arr2
Set index := 0
Set result := empty array
Iterate while index < arr1 size
  Construct array [arr1[index], arr2[index]]
  Push to result
Return result
=end

def zip(array1, array2)
  result = []
  index = 0
  while index < array1.size
    result << [array1[index], array2[index]]
    index += 1
  end
  result
end

def zip(array1, array2)
  result = []
  array1.each_with_index do |element, index|
    result << [element, array2[index]]
  end
  result
end

def zip(array1, array2)
  array1.each_with_index.with_object([]) do |(element, index), result|
    result << [element, array2[index]]
  end
end

p zip([1, 2, 3], [4, 5, 6]) == [[1, 4], [2, 5], [3, 6]]