<u>Code examples and Questions</u>



<u>Closures, binding, scope</u>

Q: What do we mean when we say that a closure creates a binding?

<details>
  <summary><u>Answer</u></summary>
  "A closure retains access to variables, constants, and methods that were in scope at the time and location where the closure was created. It binds some code with the in-scope items" - Lesson 1 Quiz Question 2</details>



What will this code do and why?

```ruby
def call_chunk(code_chunk)
  code_chunk.call
end

say_color = Proc.new {puts "The color is #{color}"}
color = "blue"
call_chunk(say_color)
```



Which of these names is part of the binding for the block body on line 12: `ARRAY`, `abc`, `xyz`, `collection`, `a`?

```ruby

 ARRAY = [1, 2, 3]

def abc
  a = 3
end

def xyz(collection)
  collection.map { |x| yield x }
end

xyz(ARRAY) do
  # block body
end
```



Example demonstrates that a closure can update variables in their surrounding scope even when they are called from a different scope.

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

"Though the block passed to `for_each_in` is invoked from inside `for_each_in` the block still has access to the `results` array through closure"



This example demonstrates returning a `Proc` from a method.

```ruby
def sequence
  counter = 0
  Proc.new { counter += 1 }
end

s1 = sequence
p s1.call           # 1
p s1.call           # 2
p s1.call           # 3
puts

s2 = sequence
p s2.call           # 1
p s1.call           # 4 (note: this is s1)
p s2.call           # 2
```

"Here, the `#sequence` method returns a `Proc` that forms a closure with the local variable `counter`. Subsequently, we can call the returned `Proc` repeatedly. Each time we do, it increments its own private copy of the `counter` variable. Thus, it returns `1` on the first call, `2` on the second, and `3` on the third.

Interestingly, we can create multiple `Proc`s from `sequence`, and each will have its own independent copy of `counter`. Thus, when we call `sequence` a second time and assign the return value to `s2`, the `counter` associated with `s2` is separate and independent of the `counter` in `s1`."



"  blocks are a way to defer some implementation decisions to method  invocation time. It allows method users to refine a method at invocation time for a specific use case. It allows method implementors to build  generic methods that can be used in a variety of ways.

  blocks are a good use case for "sandwich code" scenarios, like closing a `File` automatically.

  methods and blocks can return a chunk of code by returning a `Proc` or `lambda`."



This example demonstrates reassigning the local variable after the Proc has been created. The Proc will somehow know the updated value. Why is this?

```ruby
def call_me(some_code)
  some_code.call
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"        # re-assign name after Proc initialization

call_me(chunk_of_code)
```

'The `Proc` is aware of the new value even though the variable was reassigned after the `Proc` was defined. This implies that the `Proc` keeps track of its surrounding context, and drags it around wherever the chunk of code is passed to.'

'In Ruby, we call this its **binding**, or surrounding environment/context.'

'A closure must keep track of its binding to have all the information it needs to be executed later. This not only includes **local variables**, but also **method references**, **constants** and other artifacts in your code -- whatever it needs to execute correctly, it will drag all of it around. It's why code like the above works fine, seemingly violation the variable scoping rules we learned earlier.'

'Note that any local variables that need to be accessed by a closure must be defined *before* the closure is created, unless the local variable is explicitly passed to the closure when it is called (e.g. `some_proc.call(some_variable)`).'

This example is extrapolated from the end of the assignment. It demonstrates that any local variables initialized after the Proc is defined will not be accessible in the Proc's code chunk. Thus here, `name` is not in scope for the Proc.

```ruby
def call_me(some_code)
  some_code.call
end


chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Robert"

call_me(chunk_of_code)  # raises NameError, `name` was initialized after Proc defined
```

This example demonstrates defining a method after a Proc is created, question what would happen if this code were run:

```ruby
my_proc = Proc.new { puts d }

def d
  4
end

my_proc.call
```





<u>How blocks work and when we want to use them</u>

Q: What are the two most common use cases for methods that take a block?

<details class="use-cases-blocks">
  <summary><u>Answer</u></summary>
  <ul>
    <li>To let methods perform some kind of before and after actions</li>
    <li>To defer some part of the method implementation code to method invocation</li>
  </ul>
</details>



Identify the method invocation, the calling object, the method definition, and the block:

```ruby
def add_one(number)
  number + 1
end

{ a: 1, b: 2, c: 3 }.each_value { |num| puts add_one(num) }
```



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





<u>When You Can Pass a Block to a Method</u>

Q: What kinds of methods in Ruby can take blocks?

<details class="which-methods-take-blocks">
  <summary><u>Answer</u></summary>
  All Ruby methods can accept a block argument even if a method's implementation makes no use of a block. If the implementation doesn't make use of the block, the method simply ignores it
</details>



What will this code return? Will it raise an exception?

```ruby
def increment(x)
  x + 1
end

p increment(2)
p increment(2) { |x| x ** 4 }
```



<u>Arguments and Return Values with Blocks</u>

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



<u>Arity of Blocks and Methods</u>



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



<u>Blocks and Variable Scope</u>

This example demonstrates the simplified mental model of blocks and local variable scope we learned in RB101-120:

```ruby
level_1 = "outer-most variable"

[1, 2, 3].each do |n|                     # block creates a new scope
  level_2 = "inner variable"

  ['a', 'b', 'c'].each do |n2|            # nested block creates a nested scope
    level_3 = "inner-most variable"

    # all three level_X variables are accessible here
  end

  # level_1 is accessible here
  # level_2 is accessible here
  # level_3 is not accessible here

end

# level_1 is accessible here
# level_2 is not accessible here
# level_3 is not accessible here
```



This example demonstrates that a local variable initialized in the scope where a closure is defined can be referenced by the "code chunk" of the closure even when it is called from the different, self-contained scope for local variables of a method the closure object is passed to as argument:

```ruby
def call_me(some_code)
  some_code.call    # call will execute the "chunk of code" that gets passed in
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}

call_me(chunk_of_code)
```

This example demonstrates that a closure binds to the local variable in its outer scope, it doesn't just make a copy, since we can reassign the variable after the closure is created and the closure binding will register the reassignment:

```ruby
def call_me(some_code)
  some_code.call
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"        # re-assign name after Proc initialization

call_me(chunk_of_code)
```

This example demonstrates that closures only capture/bind to local variables initialized before they are created, not after:

```ruby
def call_me(some_code)
  some_code.call
end


chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"

call_me(chunk_of_code) # raises NameError
```



<u>Create Custom Methods that Use Blocks and Procs</u>

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



<u>Methods with an Explicit Block Parameter</u>

This example demonstrates that when we pass an explicit block using `&parameter` syntax, Ruby converts the block to a Proc object:

```ruby
def test(&block)
  puts "What's &block? #{block}"
end

test { sleep 1 }

# What's &block? #<Proc:0x007f98e32b83c8@(irb):59>
# => nil
```

This example demonstrates passing an explicit block (converted to Proc object) to another method:

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

Note that you only need to use `&` for the `block` parameter in `#test`. Since `block` is already a Proc object when we call `test2`, no conversion is necessary.



This example demonstrates passing arguments to the explicit block by using them as arguments to `Proc#call`:

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



<u>Symbol to Proc</u>

This example demonstrates a `map` call that uses a block argument to transform every element in an array using the `Integer#to_s` method, and then another call to `map` that uses `&:symbol` syntax to do the same thing:

```ruby
[1, 2, 3, 4, 5].map do |num|
  num.to_s
end
# => ["1", "2", "3", "4", "5"]

[1, 2, 3, 4, 5].map(&:to_s)                     # => ["1", "2", "3", "4", "5"]
```

This example demonstrates chaining iterator method calls that use `&:symbol` syntax:

```ruby
[1, 2, 3, 4, 5].map(&:to_s).map(&:to_i)         # => [1, 2, 3, 4, 5]
```

This example demonstrates a selection of iterator calls using `&:symbol` syntax:

```ruby
["hello", "world"].each(&:upcase!)              # => ["HELLO", "WORLD"]
[1, 2, 3, 4, 5].select(&:odd?)                  # => [1, 3, 5]
[1, 2, 3, 4, 5].select(&:odd?).any?(&:even?)    # => false
```

This example demonstrates use of `&` to convert a Symbol to a Proc and then the Proc to a block:

```ruby
def my_method
  yield(2)
end

# turns the symbol into a Proc, then & turns the Proc into a block
my_method(&:to_s)               # => "2"
```

This example demonstrates converting a Symbol to a Proc and then using the `&` operator on the variable that references the Proc:

```ruby
def my_method
  yield(2)
end

a_proc = :to_s.to_proc          # explicitly call to_proc on the symbol
my_method(&a_proc)              # convert Proc into block, then pass block in. Returns "2"
```



<u>Understand Methods Can Return Closures</u>

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
