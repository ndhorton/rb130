Understand methods can return closures

Material

1:4: Writing Methods that take Blocks



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