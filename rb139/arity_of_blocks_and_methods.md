Arity of blocks and methods



Material

1:4



"The rule regarding the number of arguments that you must pass to a block, proc, or lambda in Ruby is called its **arity**. In Ruby, blocks and procs have **lenient arity**, which is why Ruby doesn't complain when you pass in too many or too few arguments to a block. Methods and lambdas, on the other hand, have **strict arity**, which means you must pass the exact number of arguments that the method or lambda expects. For now, the main thing you should remember about arity is that methods enforce the argument count, while blocks do not. You don't need to remember the details about procs and lambdas"

If we pass too few arguments to a block or proc, the parameters without corresponding arguments will be initialized to `nil`.



Code Examples



This example demonstrates passing too many arguments to the block:

```ruby
# method implementation
def test
  yield(1, 2) # passing 2 block arguments at block invocation time
end

# method invocation
test { |num| puts num } # expecting 1 parameter in block implementation
```



This example demonstrates passing too few arguments to the block (maybe rewrite to give a more explicit representation of `nil`?):

```ruby
# method implementation
def test
  yield(1)    # passing 1 block argument at block invocation time
end

# method invocation
test do |num1, num2| # expecting 2 parameters in block implementation
  puts "#{num1} #{num2}"  # outputs "1 "
end
```

This example demonstrates a method that uses the return value from the block:

```ruby
def compare(str)
  puts "Before: #{str}"
  after = yield(str)
  puts "After: #{after}"
end

# method invocation
compare('hello') { |word| word.upcase }
compare('hello') { |word| word.slice(1..2) }
compare('hello') { |word| "nothing to do with anything" }
compare('hello') { |word| puts "hi" }
```

