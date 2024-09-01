# build a `select` method

def select(array)
  counter = 0
  result = []

  while counter < array.size
    current_element = array[counter]
    result << current_element if yield(current_element)
    counter += 1
  end

  result
end

array = [1, 2, 3, 4, 5]

puts (array.select { |num| num.odd? }) == (select(array) { |num| num.odd? })
puts (array.select { |num| puts num }) == (select(array) { |num| puts num })
puts (array.select { |num| num + 1 })  == (select(array) { |num| num + 1 })
