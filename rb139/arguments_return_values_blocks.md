Arguments and Return Values with Blocks



Material

1:4



Yielding with an argument

```ruby
3.times do |num|
  puts num
end
```

"The `do...end` is the block. The `num` variable between the two `|`s is a *parameter* for the block, or, more simply, a *block parameter*. Within the block, `num` is a *block local variable*. This is a special type of local variable where the scope is constrained to the block."

Probably better to say a special scope for local variables limited confined to the block (and any blocks nested inside the block, which would capture the variable in their own bindings).

"It's [usually] important to make sure the block parameter has a unique name and doesn't conflict with any local variables [in the surrounding scope]. Otherwise, you'll encounter *variable shadowing*... Shadowing makes it impossible to access the variable defined in the outer scope, which is usually not what you want."

"The rule regarding the number of arguments that you must pass to a block, proc, or lambda in Ruby is called its **arity**. In Ruby, blocks and procs have **lenient arity**, which is why Ruby doesn't complain when you pass in too many or too few arguments to a block. Methods and lambdas, on the other hand, have **strict arity**, which means you must pass the exact number of arguments that the method or lambda expects. For now, the main thing you should remember about arity is that methods enforce the argument count, while blocks do not. You don't need to remember the details about procs and lambdas"

Return value of Yielding to the Block

A block's return value is "based on the last expression in the block. This implies that just like normal methods, blocks can either mutate the argument with a destructive method call or the block can return a value."



Code examples

This example demonstrates a method that passes an argument to be assigned to the block parameter, via `yield()`:

```ruby
# method implementation
def increment(number)
  if block_given?
    yield(number + 1)
  end
  number + 1
end

# method invocation
increment(5) do |num|
  puts num
end
```

The above method invocation outputs `6`. Notice the use of `block_given?`, which allows us to continue to call the method without a block. Let's trace the code execution in the above code snippet.

1.  Execution starts at method invocation on line 10.
2.  Execution moves to the method implementation on line 2, which sets `5` to the local variable `number`, and the block is not set to any variable; it's just implicitly available.
3.  Execution continues on line 3, which is a conditional.
4.  Our method invocation has indeed passed in a block, so the conditional is true, moving execution to line 4.
5.  On line 4, execution is yielded to the block (or the block is called), and we're passing `number + 1` to the block. This means we're calling the block with `6` as the block argument.
6.  Execution jumps to line 10, where the block parameter `num` is assigned `6`.
7.  Execution continues to line 11, where we output the block local variable `num`.
8.  Execution continues to line 12, where the end of the block is reached.
9.  Execution now jumps back to the method implementation, where we just finished executing line 4.
10. Execution continues to line 5, the end of the `if`.
11. Line 6 returns the value of the incremented argument to line 10.
12. The program ends (the return value of `#increment` is not used)



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

