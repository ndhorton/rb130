Create Custom Methods that Use Blocks and Procs

Material 1:4-8





Code examples

This example demonstrates a naive custom `times` method:

```ruby
# method implementation
def times(number)
  counter = 0
  while counter < number do
    yield(counter)
    counter += 1
  end

  number                      # return the original method argument to match behavior of `Integer#times`
end

# method invocation
times(5) do |num|
  puts num
end

# Output:
# 0
# 1
# 2
# 3
# 4
# => 5
```



This example demonstrates a naive custom `each` method:

```ruby
def each(array)
  counter = 0

  while counter < array.size
    yield(array[counter])                           # yield to the block, passing in the current element to the block
    counter += 1
  end

  array                                             # returns the `array` parameter, similar in spirit to how `Array#each` returns the caller
end

each([1, 2, 3, 4, 5]) do |num|
  puts num
end

# 1
# 2
# 3
# 4
# 5
# => [1, 2, 3, 4, 5]
```



This example demonstrates a naive custom `select` method:

```ruby
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

select(array) { |num| num.odd? }      # => [1, 3, 5]
select(array) { |num| puts num }      # => [], because "puts num" returns nil and evaluates to false
select(array) { |num| num + 1 }       # => [1, 2, 3, 4, 5], because "num + 1" evaluates to true
```



This example demonstrates using a block's closure to update a variable in the surrounding scope, even though the block is called (yielded to) from a different scope:

```ruby
def for_each_in(arr)
  arr.each { |element| yield element }
end

arr = [1, 2, 3, 4, 5]
results = [0]

for_each_in(arr) do |number|
  total = results[-1] + number
  results.push(total)
end

p results # => [0, 1, 3, 6, 10, 15]
```



This example demonstrates a method that returns a Proc:

```ruby
def for_each_in(arr)
  arr.each { |element| yield element }
end

arr = [1, 2, 3, 4, 5]
results = [0]

for_each_in(arr) do |number|
  total = results[-1] + number
  results.push(total)
end

p results # => [0, 1, 3, 6, 10, 15]
```

"Here, the `#sequence` method returns a `Proc` that forms a closure with the local variable `counter`. Subsequently, we can call the returned `Proc` repeatedly. Each time we do, it increments its own private copy of the `counter` variable. Thus, it returns `1` on the first call, `2` on the second, and `3` on the third.

Interestingly, we can create multiple `Proc`s from `sequence`, and each will have its own independent copy of `counter`. Thus, when we call `sequence` a second time and assign the return value to `s2`, the `counter` associated with `s2` is separate and independent of the `counter` in `s1`.

We'll cover closures in far more detail later in the curriculum,  though not with Ruby. For now, just remember that methods and blocks can return `Proc`s and `lambda`s that can subsequently be called."
