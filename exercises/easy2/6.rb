# each_with_index

def each_with_index(collection)
  counter = 0
  while counter < collection.size
    yield(collection[counter], counter)
    counter += 1
  end
  collection
end

# LS solution
def each_with_index(collection)
  index = 0
  collection.each do |item|
    yield(item, index)
    index += 1
  end
end

result = each_with_index([1, 3, 6]) do |value, index|
  puts "#{index} -> #{value**index}"
end

puts result == [1, 3, 6]