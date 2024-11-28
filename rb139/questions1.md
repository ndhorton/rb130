

<u>Closures, binding, scope</u>

1. What do we mean when we say that a closure creates a binding?

<details>
  <summary><u>Answer</u></summary>
  "A closure retains access to variables, constants, and methods that were in scope at the time and location where the closure was created. It binds some code with the in-scope items" - Lesson 1 Quiz Question 2</details>




2. What will this code do and why?

```ruby
def call_chunk(code_chunk)
  code_chunk.call
end

say_color = Proc.new {puts "The color is #{color}"}
color = "blue"
call_chunk(say_color)
```

On line 5, we initialize local variable `say_color` to a new Proc object. After this, on line 6, we initialize local variable `color` to the String `"blue"`.

On line 7, we call the `call_chunk` method, passing `say_color` as argument.

The `call_chunk` method is defined on lines 1-3 with one parameter `code_chunk`, which on this invocation is assigned to the `say_color` Proc object. Within the method definition body, on line  2, we call the `Proc#call` method on `code_chunk`. This will raise a `NameError`.

The reason for this has to do with how Ruby closures bind local variables. When we call `call` on the `code_chunk` Proc on line 2, the flow of execution jumps to the `code_chunk` code chunk, defined on line 5 where it was passed to the `Proc.new` method as a block. The only line in this code chunk is a `Kernel#puts` statement, which is passed a string that interpolates a local variable or method called `color`. Since the local variable `color` is not initialized until line 6, after the Proc is created, and we have not defined a `color` method, the `NameError` exception is raised. A Ruby closure, such as a Proc, will only bind local variables that are initialized before the closure is created.

This example demonstrates Ruby closures, binding and scope. Specifically, it demonstrates that a closure, in this case a `Proc`, will only bind local variables that are initialized before the point in the program where the `Proc` is created.



3. Which of these names is part of the binding for the block body on line 12: `ARRAY`, `abc`, `xyz`, `collection`, `a`?

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

When a Ruby closure, such as a block, is created, the closure binds variables, constants, methods and other in-scope artifacts. The binding a closure creates allows the closure to be executed successfully later, even in another context and scope. 

The block defined on the `xyz` method invocation on line 11 will bind the `ARRAY` constant and the `abc` and `xyz` methods, but not the `collection` and `a` local variables.

The `ARRAY` constant is defined on line 1 within the lexical scope where the `xyz` block is defined. A closure's binding will include constants that are in lexical scope where the closure is created so long as the constant gets defined before the closure is executed. The block will be executed in the context of the `xyz` method invocation on which it is defined on line 11. This means that the `ARRAY` constant has been defined by the time the block executes, and so forms part of the closure's binding. `ARRAY` can therefore be referenced within the block without namespace qualification.

The `abc` instance method is defined on lines 3-5 within the scope where the `xyz` block is defined (the top-level or `main` scope). A method will form part of a closure's binding if it is within scope and so long as it is defined before the closure is executed. Since the `abc` method definition is within scope, and the block will be executed after `abc` is defined, the `abc` method can be said to be part of the binding of the block.

The `xyz` method is defined on lines 7-9 within scope of the block and before the block is executed. For the same reasons as the `abc` method, the `xyz` method will form part of the block's binding.

The `a` local variable is local to the `abc` instance method definition. Since a method definition creates its own scope for local variables, and the `xyz` block defined on line 11 is not in the same scope with respect to local variables, the `a` variable will not form part of the block's scope and cannot be accessed by it.

Similarly, the `collection` method parameter of the `xyz` method (line 7) is a local variable that is local to the `xyz` method definition. Since the block is in a different scope with respect to local variables, `collection` will not form part of the block's binding.

This example demonstrates Ruby closures and their binding with respect to the scopes of local variables, constants and instance method definitions.



4. If methods have self-contained scope with respect to local variables, how is it that the `results` array comes to have objects added to it between lines 6 and 13?

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

On line 5, we initialize local variable `arr` to the array `[1, 2, 3, 4, 5]`. On line 6, we initialize `results` to another array, `[0]`.

On line 8, we call the `for_each_in` method with a block (lines 8-11). We pass `arr` as argument to `for_each_in`.

The `for_each_in` method is defined on lines 1-3 with one parameter, also named `arr`, to which the `arr` array instantiated on line 5 is assigned. The body of the method definition calls `each` on this array with a block, which will `yield` each element of `arr` in turn to the block defined on the `for_each_in` method invocation on lines 8-11.

Execution passes to the block on line 8. Each element of `arr` is in turn assigned to the block-local variable `number`. Within the body of the block on line 9, we initialize block-local variable `total` to the return value of the expression `results[-1] + number`. The reason we can access the `results` local variable within the block is that blocks, like all  Ruby closures, bind in-scope local variables at the time and location the block is defined. Since `results` is initialized in the same scope the block is defined within before the block is defined, the local variable forms part of the block's binding. This means we can access and even reassign `results` from within the block, even though the block has been called by the `for_each_in` method, which does not have access to the `results` variable since method scope is self-contained with respect to local variables.

Therefore, when we call the mutating method `Array#push` on `results` on line 10, we are updating the state of the object referenced by the local variable `results` that was initialized on line 6 because the block has access to the same `results` variable.

Thus when the `for_each_in` method returns, and we pass `results` to the `Kernel#p` method on line 13, the output will reflect the mutations made by each call to the block: `[0, 1, 3, 6, 10, 15]`.

This example demonstrates Ruby closures, binding, and scope; specifically, it shows that blocks retain access to the in-scope local variables initialized before the block is defined even though the method invocation on which the block is defined does not itself have access to those variables.





5. Explain what the objects referenced by `s1` and `s2` are and how they are produced. Why are the values returned by `s1.call` independent from those returned by `s2.call`?

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

On line 6, we initialize local variable `s1` to the object returned by the `sequence` method.

We define the `sequence` method on lines 1-4 with no parameters. Within the method definition body, we initialize method-local variable `counter` to `0`. On the next and final line, we instantiate a Proc object, passing a block that will form the closure's code chunk: `{ counter += 1 }`. Since this is the last evaluated expression in the method body, it forms the method's return value. This Proc is therefore the object to which `s1` is initialized on line 6.

Since a Proc object is a closure, it retains access to local variables that are in scope at the time and location of the program where the Proc is created. This means that `s1` can still access the `counter` local variable initialized during this `sequence` method invocation, even though the method call has returned. The variable is kept alive by the binding of the `s1` Proc.

On line 7, we call `Proc#call` on `s1`. The only line in the code chunk `counter += 1` reassigns the Proc's `counter` variable to the Integer one higher than the one it currently references. This forms the return value of the Proc. Lines 7-9 demonstrate that each time the Proc is called, the next integer in the sequence is returned.

Methods have self-contained scope with respect to local variables. Each time a method is called, all of its method-local variables will be created anew; they will not be the same variables that existed under the same names on any previous method call. Therefore, a new `counter` variable is created each time the `sequence` method is called, meaning that the `s1` Proc now has exclusive access to this variable. If we call the method again, a new `counter` local variable is created, and a new Proc object instantiated and returned, again with exclusive access to that particular `counter` variable.

So when we initialize `s2` to a new Proc object returned by another call to `sequence`, it has access to a different and separate `counter` variable from the `s1` Proc. This is demonstrated by the output from lines 13-15, where we call `call` on `s1` and `s2` and pass the return values to `p`. We can see that each Proc is at a different point in the sequence of integers it encapsulates.

This example demonstrates Ruby closures, binding, and scope; specifically it demonstrates that Procs returned by method invocations can extend the lifetime of method-local variables and retain access to them through their binding even when the method call has returned. It also shows that each time a method is called, it initializes a new set of method-local variables for that particular invocation.



6. What will line 9 return and why?

```ruby
def call_me(some_code)
  some_code.call
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"

call_me(chunk_of_code)
```

On line 5, we initialize local variable `name` to the string `"Robert"`. After this, on line 6, we initialize local variable `chunk_of_code` to a new Proc object, whose code chunk, passed to `Proc.new` as a block, interpolates the `name` local variable into a string and passes it to `Kernel#puts` to be output.

On line 7, after we have instantiated the `chunk_of_code` Proc, we reassign `name` to a new string, `"Griffin III"`. On line 9, we pass `chunk_of_code` to the `call_me` method.

The `call_me` method is defined on lines 1-3 with one parameter, `some_code`, which on this invocation is assigned to the `chunk_of_code` Proc. Within the method body, we call `Proc#call` on `some_code`. Execution flow passes to the Proc's chunk of code, defined on line 6, and the `puts` method outputs `"hi Griffin III"` to the screen.

A Proc object is a closure. Closures in Ruby retain access to the local variables and other necessary artifacts in scope at the time and location in the program where the closure is created; we say that the closure *binds* to the in-scope items. As long as a local variable is in scope and has been initialized before the closure is created, it can be accessed if necessary by the closure's chunk of code. The closure binds the variable, not simply the value of the variable, and so if the variable is subsequently reassigned outside of the closure's code before the closure is executed, then the reassignment will be reflected in the closure. This is because the closure has access to the variable itself, not simply a reference to the object the variable references. And this is why the output of our code, `"hi Griffin III"`, reflects the local variable reassignment that takes place after the closure is created.

This example demonstrates Ruby closures and the way in which they bind in-scope local variables.



7. What will line 9 return and why?

```ruby
def call_me(some_code)
  some_code.call
end


chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Robert"

call_me(chunk_of_code)
```

On line 6, we initialize local variable `chunk_of_code` to a new Proc object, instantiated by passing the block `{ puts "hi #{name}" }` to `Proc.new`. It should be noted that this chunk of code references a local variable or method called `name`.

On line 7, we initialize local variable `name` to a string `"Robert"`. Then on line 9, we call `call_me`, passing `chunk_of_code` as argument.

The `call_me` method is defined on lines 1-3 with one parameter `some_code`, which on this invocation is assigned to the `chunk_of_code` Proc. Within the method body, we call `Proc#call` on `some_code`.

Execution passes to the Proc' s code, defined on line 6. The attempt to interpolate `name` into the string raises a `NameError` exception. The reason for this has to do with the way Ruby implements closures and their binding in relation to local variable scope.

Closures retain access to variables and other artifacts in scope at the time and location in the program where the closure is created. We say that the closure *binds* the code it encapsulates to the in-scope items. However, this means that local variables must be initialized before the closure is defined in order for the closure to bind them. Since the `name` local variable is initialized on line 7, after the closure is created on line 6, the Proc's binding does not include a local variable called `name`. Since we have not defined a method of that name either, `name` cannot be resolved and a `NameError` exception is raised.

This example demonstrates Ruby closures, binding and scope; specifically, it shows that a local variable must be initialized before a closure is created in order for the variable to form part of the closure's binding.



8. Will this code produce an error? Why, or why not?

```ruby
my_proc = Proc.new { puts d }

def d
  4
end

my_proc.call
```

On line 1, we initialize local variable `my_proc` to a new Proc object, passing the block `{ puts d }` to `Proc.new`.

On lines 3-5, we define the `d` method. The `d` method simply returns the integer `4`.

On line 7, we call `Proc#call` on `my_proc`. Execution passes to the Proc's chunk of code, defined on line 1. We successfully call the `d` method and the return value is passed to `Kernel#puts` to be output to screen: `4`.

The reason this does not raise an exception has to do with the difference between the way Ruby closures bind the different types of in-scope artifacts.

In Ruby, closures, including Proc objects, retain access to the variables, constants and methods that are in scope at the time and location in the program where the closure is created; the closure binds its code chunk with the in-scope artifacts. For local variables, this involves keeping track of which local variables have been initialized in the current scope *before* the point where the closure is created. If a local variable is initialized within the same scope for local variables but *after* the creation of the closure, the closure will not bind that local variable. For methods, the case is different.

In Ruby, unlike in some languages, a new method can be added to a class at any time in the program. Method invocation in Ruby is handled dynamically such that so long as a method definition exists by the time it is invoked, the method will be successfully called.

Methods that are defined at top-level are implicitly defined as private instance methods of the Object class, from which almost every class in Ruby inherits. This is why top-level methods are available to be called (almost) everywhere. When we call a top-level method without an explicit caller, we are implicitly calling it on `self`, which everywhere (except within a BasicObject instance) references an instance of some class that inherits from Object, since nearly every class inherits from Object. At top-level, `self` references `main`, a special instance of the Object class in whose context (most) top-level code executes.

One of the artifacts bound by a Ruby closure is the current value of `self`. All method calls without an explicit caller are called implicitly on the object currently referenced by `self`. Therefore, so long as a top-level method of a name used in a closure's code chunk is defined before that closure is actually executed, the method will be called successfully.

That is why, in this code example, we can define the `d` method after the closure is created, but before it is executed, and the closure's code can still successfully call the `d` method without raising an exception. The method definition exists by the time the code executes and so Ruby successfully finds a method of the name `d` in the method lookup path for `self`. 

This example demonstrates Ruby closures, binding and scope with respect to methods.



9. What is the flow of execution? What is the object referenced by `chunk_of_code`? What is output and why?

```ruby
def call_me(some_code)
  some_code.call
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}

call_me(chunk_of_code)
```



10. What does this code output and why?

```ruby
def call_me(some_code)
  some_code.call
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"

call_me(chunk_of_code)
```





<u>How blocks work and when we want to use them</u>

11. What are the two most common use cases for methods that take a block?

<details class="use-cases-blocks">
  <summary><u>Answer</u></summary>
  <ul>
    <li>To let methods perform some kind of before and after actions</li>
    <li>To defer some part of the method implementation code to method invocation</li>
  </ul>
</details>


12. Identify the method invocation, the calling object, the method definition, and the block.

```ruby
def add_one(number)
  number + 1
end

{ a: 1, b: 2, c: 3 }.each_value { |num| puts add_one(num) }
```



13. Describe the flow of execution. Pay attention to arguments passed and return values.

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



14. What is the entity on lines 1-6, and what role does its author occupy? What is the entity on lines 8-9 and what role does its author occupy? Describe the flow of execution.

```ruby
def increment(number)
  if block_given?
    yield(number + 1)
  end
  number + 1
end

increment(5) do |num|
  puts num
end
```



15. Describe this code and its limitations. What might we do to make it more flexible?

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
```



16. What does this code output and why? How is the block being used?

```ruby
def compare(str)
  puts "Before: #{str}"
  after = yield(str)
  puts "After: #{after}"
end

compare('hello') { |word| word.upcase }
```



17. What does this code do? What use case of blocks does the `time_it` method represent?

```ruby
def time_it
  time_before = Time.now
  yield
  time_after= Time.now

  puts "It took #{time_after - time_before} seconds."
end

time_it { sleep(3) }

time_it { "hello world" }
```



18. How do the two pieces of code below differ? Is there an advantage to one over the other?

a)

```ruby
file = File.open("some_file.txt", "w+")
file.write("Four score and seven years ago")
file.close
```

b)

```ruby
File.open("some_file.txt", "w+") do |file|
  file.write("Four score and seven years ago")
end
```



19. What is happening in the first line of the code below? What will the output of the `test` method call be?

```ruby
def test(&block)
  puts "What's &block? #{block}"
end

test { sleep(1) }
```



20. Describe the flow of execution and output of the code below. How do the parameter lists of the `test` and `test2` methods differ, and why?

```ruby
def test2(block)
  puts "hello"
  block.call
  puts "good-bye"
end

def test(&block)
  puts "1"
  test2(block)
  puts "2"
end

test { puts "xyz" }
```



21. Describe the flow of execution and output of the code below.

```ruby
def display(block)
  block.call(">>>")
end

def test(&block)
  puts "1"
  display(block)
  puts "2"
end

test { |prefix| puts prefix + "xyz" }
```



22. Describe the flow of execution and output of the code below

```ruby
def times(number)
  counter = 0
  while counter < number do
    yield(counter)
    counter += 1
  end

  number
end

times(5) do |num|
  puts num
end
```



23. Describe the flow of execution and output of the code below

```ruby
def each(array)
  counter = 0

  while counter < array.size
    yield(array[counter])
    counter += 1
  end

  array                                      
end

each([1, 2, 3, 4, 5]) do |num|
  puts num
end
```



24. Describe the flow of execution and return values of the code below up to line 16. What does line 18 return? And line 19?

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

select(array) { |num| num.odd? }

select(array) { |num| puts num }
select(array) { |num| num + 1 }
```



<u>When You Can Pass a Block to a Method</u>

25. What kinds of methods in Ruby can take blocks?

<details class="which-methods-take-blocks">
  <summary><u>Answer</u></summary>
  All Ruby methods can accept a block argument even if a method's implementation makes no use of a block. If the implementation doesn't make use of the block, the method simply ignores it
</details>




What will this code return? Will it raise an exception?

```ruby
def increment(x)
  x + 1
end

p increment(2) { |x| x ** 4 }
```



<u>Blocks and Variable Scope</u>

26. In earlier courses, we learned to describe blocks in terms of "inner" and "outer" scopes, or different "levels" of nesting. How would we describe the code below with what we now know of how Ruby implements closures?

```ruby
level_1 = "outer-most variable"

[1, 2, 3].each do |n|
  level_2 = "inner variable"

  ['a', 'b', 'c'].each do |n2|
    level_3 = "inner-most variable"
  end
end
```







<u>Arity of Blocks and Methods</u>



25. Will the code below raise an error? Why, or why not?

```ruby
def test
  yield(1, 2)
end

test { |num| puts num }
```



26. Will the code below raise an error? Why or why not?

```ruby
def test
  yield(1)
end

test do |num1, num2|
  puts "#{num1} #{num2}"
end
```



27. Will the code below raise an error? Why, or why not?

```ruby
def process_number(num, &block)
  block.call(num)
end

process_number(7) { |num1, num2| num1 ** num2 }
```



28. Will the code below raise an error? Why, or why not?

```ruby
def process_number(num, &block)
  block.call(num)
end

process_number(7) { |num1, num2| num1 ** 2 }
```



29. Will the code below raise an error? Why, or why not?

```ruby
def transform_number(num, block)
  block.call(num)
end

l = lambda { |num1, num2| num1 ** num2 }
```





<u>Arguments and Return Values with Blocks</u>



28. Describe the flow of execution up to line 7. What will the of `after` on line 3 be for all the calls to `compare`?

```ruby
def compare(str)
  puts "Before: #{str}"
  after = yield(str)
  puts "After: #{after}"
end

compare('hello') { |word| word.upcase }
compare('hello') { |word| word.slice(1..2) }
compare('hello') { |word| "nothing to do with anything" }
compare('hello') { |word| puts "hi" }
```



<u>Blocks and Variable Scope</u>



29. Explain why the call to `for_each_in` on line 8 is able to mutate the `results` array even though we never pass `results` to `for_each_in` as a method parameter.

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



32. Will this code raise an error? Why, or why not?

```ruby
def call_me(some_code)
  some_code.call
end


chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"

call_me(chunk_of_code)
```



<u>Create Custom Methods that Use Blocks and Procs</u>

33. Describe the flow of execution and what is output.

```ruby
def times(number)
  counter = 0
  while counter < number do
    yield(counter)
    counter += 1
  end

  number                     
end

times(5) do |num|
  puts num
end
```



34. Describe the flow of execution and output.

```ruby
def each(array)
  counter = 0

  while counter < array.size
    yield(array[counter])                          
    counter += 1
  end

  array  
end

each([1, 2, 3, 4, 5]) do |num|
  puts num
end
```



35. Describe the flow of execution and give the return values for lines 16, 17, and 18.

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

select(array) { |num| num.odd? }
select(array) { |num| puts num }
select(array) { |num| num + 1 }
```





<u>Methods with an Explicit Block Parameter</u>

36. What is the object referenced by method-local variable `block` and where does it come from?

```ruby
def test(&block)
  puts "What's &block? #{block}"
end

test { sleep 1 }
```



37. Why do use an explicit rather than implicit block in our `test` method?

```ruby
def test2(block)
  puts "hello"
  block.call
  puts "good-bye"
end

def test(&block)
  puts "1"
  test2(block)
  puts "2"
end

test { |prefix| puts "xyz" }
```





38. Describe the flow of execution. What is output and why?

```ruby
def display(block)
  block.call(">>>")
end

def test(&block)
  puts "1"
  display(block)
  puts "2"
end

test { |prefix| puts prefix + "xyz" }
```





<u>Symbol to Proc</u>

39. Are the two calls to `map` equivalent? Why, or why not?

```ruby
[1, 2, 3, 4, 5].map do |num|
  num.to_s
end

[1, 2, 3, 4, 5].map(&:to_s)
```



40. Describe the method calls and return values in the code sample below.

```ruby
[1, 2, 3, 4, 5].map(&:to_s).map(&:to_i)
```



41. Describe the method calls and return values in the code sample below.

```ruby
["hello", "world"].each(&:upcase!)          
[1, 2, 3, 4, 5].select(&:odd?)              
[1, 2, 3, 4, 5].select(&:odd?).any?(&:even?)
```



42. What is the meaning of the `&` operator on line 6?

```ruby
def my_method
  yield(2)
end

my_method(&:to_s)
```



43. What happens on lines 5 and 6?

```ruby
def my_method
  yield(2)
end

a_proc = :to_s.to_proc
my_method(&a_proc)
```





<u>Understand Methods Can Return Closures</u>



44. Why do the objects returned by the `sequence` method continue to have access to the `counter` local variable if the method has returned? Do they both have access to the same `counter`?

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

