Material

1:3 Calling Methods with Blocks

1:4 Writing Methods with Blocks

1:5 - 1:8 Building naive implementations of iterator methods

Could redo the `TodoList` assignments.



notes

Lesson 1:3

Basically just points out that a block is an argument passed to a method call,  and is not actually part of the implementation, which is what decides what the method does with the block and its return value.

* A block is an argument to a method invocation. What the method does with the block, if anything, is determined by the method implementation.
* Often, you'll have to study documentation or play around with the method to understand how passing in blocks will affect its behavior (i.e. for Ruby core methods written in C as part of the Ruby implementation)

Lesson 1:4

* A block is not like a regular argument. Every method in Ruby can optionally take a block as an implicit argument even if the implementation makes no reference to a block.

Yielding

* One way to invoke a passed in block is to use the keyword `yield`
* The `yield` keyword executes the block
* The number of arguments at method invocation needs to match the required parameters in the method definition, regardless of whether we are passing in a block

"If your method implementation contains a `yield`, a developer using your method can come in after this method is fully implemented and inject additional code in the middle of this method (without modifying the method implementation), by passing in a block of code. This is indeed one of the major use cases of using blocks, which we'll talk more about later."

* If a method that uses `yield` unconditionally is called without being passed a block, `yield` raises a `LocalJumpError`.
* We can wrap `yield` in a conditional with the `Kernel#block_given?` method

**Passing execution to the block**

Given the number of occurrences of these lists tracing the execution of a block, it seems worth practicing a couple of these.

1. Execution starts at method invocation on line 8. The `say` method is called with a string, `"hi there"`, and a block passed as argument.
2. Execution goes to line 2, where the `say` method definition assigns `"hi there"` to the parameter `words`. **The block is passed in implicitly, without being assigned to a variable**.
3. Execution moves to line 3, where the `block_given?` method is used in an `if` condition. If a block has been passed, as it has, we call the block with the `yield` keyword.
4. Execution moves to line 10, the body of the block. We pass the command `'clear'` to the `Kernel#system` method as a string, which clears the terminal.
5. Since we have reached the end of the block, execution returns to the `say` method definition, returning the last evaluated expression in the block `true`. Execution moves to line 4. We concatenate `words` to the string `"> "` and pass the new string to `Kernel#puts` which outputs `"> hi there"`.
6. Since we have reached the end of the `say` method definition, execution returns the last evaluated expression `nil` to the point of invocation on line 8. This is the end of the program. 

* When we encounter `yield`, execution jumps to somewhere else (the block) and then jumps back. This is why it's sometimes useful to think of blocks as anonymous methods.

* We can pass arguments to the block by passing them to the `yield` keyword.
* A block parameter, or a local variable initialized in a block, is called a *block-local variable*

* The rule regarding the number of arguments that you must pass to a block, `proc` or `lambda` in Ruby is called its **arity**.
* Blocks and procs have **lenient arity**. Methods and lambdas have **strict arity**.
* Lenient arity means that we do not have to pass all the arguments, or only the arguments, defined as block (or proc) parameters. This is similar to the rules of parallel assignment. Matz'z book describes block/proc lenient arity as "block semantics".
* Strict arity means we must pass the correct number of arguments determined by a method (or lambda) definition.

**Return value of yielding to blocks**

"This implies that just like normal methods, blocks can either mutate the argument with a destructive method call or the block can return a value. Just like writing good normal methods, writing good blocks requires you to keep this distinction in mind."

I would have thought this is also dictated to a degree by the method that uses the block. It's probably bad to mutate values in a `map` call because `map` uses the return value and that is the primary purpose of `map`. In an `each` call, there's no point returning a meaningful value from the block since `each` will ignore it.

* Like methods, blocks can either mutate the argument with a destructive method call or return a value. It is best to keep this distinction in mind (side effects vs meaningful return value). Which one we choose is also dependent on how the block is used by the method we are passing the block to.

"There are many ways that blocks can be useful, but the two main use cases are:

1. Defer some implementation code to method invocation decision ...
2. Methods that need to perform some "before" and "after" actions -- sandwich code."

* There are two main uses of blocks. Blocks can be used to defer some implementation code to method invocation time; and blocks can be used in "sandwich code" by a method that needs to perform some "before" and "after" actions.
* There are two roles involved with any method: the **method implementer** and the **method user** (which could be the same person ).
* Without blocks/closures, we might have to define methods using flag arguments to determine from a limited number of predefined options. Blocks give us much more flexibility.
* Blocks give us flexibility by allowing the method user to **refine** the method implementation at the point of invocation, **without** modifying the method for other users. This allows us to write more generic methods with a wider number of possible uses.
* Many of the core library's most useful methods are useful precisely because they are built in a generic sense, allowing us (the code that calls the method) to refine the method through a block at invocation time. Examples include the `Array#select` method,
* If you find yourself writing multiple methods that differ in small tweaks, or a single method that uses multiple flags to determine what logic to perform, it might be better to re-implement as a single generic method that yields to a block.
* Sandwich code is perhaps an example of the more general point about deferring implementation to method invocation. It refers to situations in which the logic between a "before" and "after" action is left very open-ended, since the method itself only has one responsibility.
* The before/after action could be required for a range of different things: timing, logging and notification systems are all good examples. Or it could be to acquire, and then release, system, network, or database resources. The code in the middle is not the responsibility of the method; the method only needs to ensure that something happens before the code in the block is executed and that something happens after. The `File::open` method is an example of this. 

**Methods with an explicit block parameter**

* Normally, we pass a block to a method *implicitly*: without an explicit block parameter in the parameter list of the method definition.
* Every Ruby method can take an implicit block argument, even if the method implementation makes no use of one.
* You can also define a method to take an explicit block parameter. Specifically, by prefixing the name of a parameter with the `&` operator, Ruby will convert a given block to a Proc object and assign it to the parameter. Since it is now an object, it can be passed around, returned, and invoked many times.



<u>When to use blocks in your own methods</u>



Code Examples

This example demonstrates a simple custom method that uses a block. Describe the flow of execution. Pay attention to arguments passed and return values.

```ruby
# method implementation
def say(words)
  yield if block_given?
  puts "> " + words
end

# method invocation
say("hi there") do
  system 'clear'
end  # clears screen first, then outputs "> hi there"
```

This example demonstrates a simple custom method that uses a block. Describe the flow of execution.

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

This example demonstrates a block's lenient arity.

```ruby
# method implementation
def test
  yield(1, 2) # passing 2 block arguments at block invocation time
end

# method invocation
test { |num| puts num } # expecting 1 parameter in block implementation
```

This example demonstrates a block's lenient arity.

```ruby
# method implementation
def test
  yield(1)    # passing 1 block argument at block invocation time
end

# method invocation
test do |num1, num2| # expecting 2 parameters in block implementation
  puts "#{num1} #{num2}"
end
```

This example demonstrates using the return value of the block

```ruby
def compare(str)
  puts "Before: #{str}"
  after = yield(str)
  puts "After: #{after}"
end

# method invocation
compare('hello') { |word| word.upcase }
```

This example demonstrates how things might be without blocks/closures, by using a much less flexible system of predefined flags:

```ruby
def compare(str, flag)
  after = case flag
          when :upcase
            str.upcase
          when :capitalize
            str.capitalize
          # etc, we could have a lot of 'when' clauses
          end

  puts "Before: #{str}"
  puts "After: #{after}"
end

compare("hello", :upcase)

# Before: hello
# After: HELLO
# => nil
```

This is an example of using blocks for a sandwich code method:

```ruby
def time_it
  time_before = Time.now
  yield                       # execute the implicit block
  time_after= Time.now

  puts "It took #{time_after - time_before} seconds."
end

time_it { sleep(3) }              # It took 3.003767 seconds.
                                  # => nil

time_it { "hello world" }         # It took 3.0e-06 seconds.
                                  # => nil
```

This is an example of sandwich code that does not take advantage of the method-with-block pattern, followed by an example of using a block instead:

```ruby
my_file = File.open("some_file.txt", "w+")          # creates a file called "some_file.txt" with write/read permissions
# write to this file using my_file.write
my_file.close

File.open("some_file.txt", "w+") do |file|
  # write to this file using file.write
end
```

This example demonstrates block-to-proc conversion with `&` in the parameter list of a method definition:

```ruby
def test(&block)
  puts "What's &block? #{block}"
end

test { sleep(1) }

# What's &block? #<Proc:0x007f98e32b83c8@(irb):59>
# => nil
```

This example demonstrates converting a block to a proc in order to pass it to another method:

```ruby
def test2(block)
  puts "hello"
  block.call          # calls the block that was originally passed to test()
  puts "good-bye"
end

def test(&block)
  puts "1"
  test2(block)
  puts "2"
end

test { |prefix| puts "xyz" }
# => 1
# hello
# xyz
# good-bye
# => 2
```

This example demonstrates calling an explicit block argument with the `Proc#call` method and passing arguments to `#call`:

```ruby
def display(block)
  block.call(">>>") # Passing the prefix argument to the block
end

def test(&block)
  puts "1"
  display(block)
  puts "2"
end

test { |prefix| puts prefix + "xyz" }
# => 1
# >>>xyz
# => 2
```

This example demonstrates that a block is a closure and has access to the local variables in the scope where it is defined even though it is called/yielded to from another self-contained scope:

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

1. Method invocation starts at line 13, when the `times` method is called with an argument, `5`, and a block of code.
2. Execution enters the first line of the method implementation at line 3, where the local variable `counter` is initialized.
3. Execution continues to line 4. The `while` conditional is evaluated. The first time through, the condition is true.
4. Execution continues to line 5, which yields to the block. This is  the same as executing the block of code, and this time, we are executing the block of code with an argument. The argument to the block is the `counter`, which is `0` the first time through.
5. Execution jumps to the block on line 13, so that the block local variable `num` is assigned to the object referenced by `counter`, i.e. `num` is assigned to `0`.
6. Execution continues in the block to line 14, which outputs the block local variable `num`.
7. Reaching the end of the block, execution continues back to the `times` method implementation on line 6, where the `counter` is incremented.
8. Reaching the end of the `while` loop, execution continues on line 4, essentially repeating steps 3 through 7.
9. At some point, the `while` conditional should return  false (otherwise, you have an infinite loop), allowing execution to flow to line 9, which doesn't do anything.
10. Reaching the end of the method at line 10, execution will return the last expression in this method, which is the `number` local variable.



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

