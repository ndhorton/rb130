# Count Items

def count(collection)
  total = 0
  collection.each { |element| total += 1 if yield(element) }
  total
end

# further exploration
def count(array, &block)
  recursive_count(array, block)
end

def recursive_count(array, index = 0, pr)
  return 0 if index == array.size
  (pr[array[index]] ? 1 : 0) + recursive_count(array, index + 1, pr)
end

# Ethan Weiner student solution
# I like this because there is no extra parameter needed, default or otherwise
def count(array, &block)
  return 0 if array.empty?
  total = count(array[1..-1], &block)
  yield(array[0]) ? total + 1 : total + 0
end

p count([1,2,3,4,5]) { |value| value.odd? } == 3
p count([1,2,3,4,5]) { |value| value % 3 == 1 } == 2
p count([1,2,3,4,5]) { |value| true } == 5
p count([1,2,3,4,5]) { |value| false } == 0
p count([]) { |value| value.even? } == 0
p count(%w(Four score and seven)) { |value| value.size == 5 } == 2
