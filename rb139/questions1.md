

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

On line 5, we initialize local variable `name` to the string `"Robert"`.

Next, on line 6, we initialize local variable `chunk_of_code` to a new Proc object, passing the block `{ puts "hi #{name}" }` to `Proc.new`.

A Proc object is one of the ways Ruby implements a closure.  A closure is a general programming concept and refers to a "chunk of code" that we can pass around and execute later. A closure retains access to variables, constants, methods and other artifacts  that are in scope at the time and location in the program where the closure is created, "closing over" the in-scope artifacts in the surrounding context which the code chunk needs to be executed later. We call this the closure's binding; the closure binds the in-scope items to the chunk of code.

On line 8, we call the `call_me` method with `chunk_of_code` passed as argument.

We define the `call_me` method on lines 1-3 with one parameter, `some_code`, which on this invocation is assigned to the `chunk_of_code` Proc. Within the method body, on line 2, the `Proc#call` method is called on `some_code`.

Execution jumps to the Proc's code, defined on line 6. The local variable `name`, initialized on line 5, is interpolated into the string `"hi #{name}"`. This is possible because the Proc bound the in-scope `name` local variable when it was created (and `name` was initialized before the Proc was created). This means the Proc retains access to `name`, even though the Proc has been called from a different scope for local variables, the `call_me` method definition.

The interpolated string is passed to `Kernel#puts` and output to screen: `"hi Robert"`. Since this is the last evaluated expression, the Proc returns `nil`, the return value of `puts`, and execution resumes on line 2. This is the end of the method definition, so `call_me` also returns `nil`.

This example demonstrates Ruby closures, binding and scope; specifically, it demonstrates that a Proc object retains access to local variables initialized in scope before the time and location the Proc is created.





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

On line 5, we initialize local variable `name` to the string `"Robert"`. Next, on line 6, we initialize local variable `chunk_of_code` to a new Proc object, passing the block `{puts "hi #{name}"}` to `Proc.new`.

A Proc is one of the ways Ruby implements a closure. A closure is a general programming concept, referring to a chunk of code that can be passed around and executed later. A closure binds its chunk of code to the variables, constants, methods and other artifacts that are in scope at the time and location where the closure is created, "closing over" the in-scope items that the code needs to be executed later.

On line 7, we reassign `name` to a new string, `"Griffin III"`. On line 9, we call the `call_me` method with the `chunk_of_code` Proc passed as argument.

We define the `call_me` method on lines 1-3 with one parameter, `some_code`, which on this invocation is assigned to the `chunk_of_code` Proc. Within the method definition body, on line 2, we call the `Proc#call` method on `some_code`.

Execution jumps to the Proc's code chunk, defined with the block on line 6. We interpolate the `name` local variable into the string `"hi #{name}"`. This is possible because the Proc bound the `name` variable when it was created, since `name` was in-scope and initialized before the Proc was created. The interpolated string is passed to `Kernel#puts` to be output: `"hi Griffin III"`.

The reason for this output is because when a Ruby closure like a Proc binds a local variable, it is the variable itself that is captured, not the object it references. So when we reassigned `name` on line 7, the reassignment is reflected in the closure's binding: the `name` variable at top-level and the `name` variable bound by the Proc are the same variable.

`puts` returns `nil` as it always does and since this is the last expression in the Proc's definition, the Proc call also returns `nil`. Since there is no more code in the method definition, this invocation of `call_me` also returns `nil`.

This example demonstrates Ruby closures, binding and scope; specifically, it shows that local variables bound by a closure can be reassigned in the original local scope after the closure is created and the closure's binding will reflect the reassignments.



<u>How blocks work and when we want to use them</u>

11. What are the two most common use cases for methods that take a block?

<details class="use-cases-blocks">
  <summary><u>Answer</u></summary>
  <ul>
    <li>To let methods perform some kind of before and after actions</li>
    <li>To defer some part of the method implementation code to method invocation</li>
  </ul>
</details>
When we are defining a method, the first main use case for having that method accept a block is when we want to defer part of the method implementation to the point of invocation. This can be an extremely powerful way to implement methods. A generic transformation method such as `Enumerable#map` that defers details of the kind of transformation it will perform to a block passed in at invocation time has vastly more use cases than a method that needs to include in its definition what operation to perform on each element of a collection. Many of Ruby's core classes and modules implement generic methods that take a block so that the method caller has the freedom to customize the implementation to the task at hand. The use of blocks offers far more flexibility when designing open-ended methods than simply allowing flags or options to be passed as arguments.

The second main use case for blocks when we are writing a method is for sandwich code purposes. Often, we will need to perform some action before doing something and then ensure some second action is performed afterwards. For instance, we often need to open a file, work with the file, and then make sure we close the file to free the file handle back to the system. Ruby's `File::open` method allows us to pass in a block that accepts the opened file as argument from the method when the method yields to the block. In the block, we can do anything we like with the file, and then once the block has returned, `File::open` closes the file for us. This ensures that the system resource is freed, without the method user having to remember to do it manually. There are many situations in programming where this sandwich pattern occurs, and Ruby blocks provide a powerful way to implement methods for such purposes. The method implementor doesn't know what the user will do in between the first and second action, and can defer all such decisions to the method user. The method user can simply write the code necessary and does not have to be concerned with details such as closing a file after use.



Might be an idea to write a stock answer to this one.





12. Identify the method invocation, the calling object, the method definition, and the block.

```ruby
def add_one(number)
  number + 1
end

{ a: 1, b: 2, c: 3 }.each_value { |num| puts add_one(num) }
```

On line 5, we invoke the `Hash#each_value` method on the Hash in literal notation, `{ a: 1, b: 2, c: 3 }`. We pass the block `{ |num| puts add_one(num) }` to the `each_value` method.

The `each_value` method iterates through the Hash passing each value-part of its members to the block in turn when the method yields to the block. At this point, execution jumps to our block, where the value object is assigned to block parameter `num`. Within the block definition, we call the `add_one` method with the `num` passed as argument. 

The `add_one` method is defined on lines 1-3 with one parameter `number`, to which the integer referenced by `num` is assigned. The method definition body returns the integer that is one higher.

Back in the block, the integer return value from `add_one` is passed to `Kernel#puts` to be output.

This code therefore outputs

```
1
2
3
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

Execution begins on line 8, where we invoke the `say` method with the string `"hi there"` passed as argument; we pass a `do...end` block, defined on lines 8-10, to the `say` invocation.

The `say` method is defined on lines 2-5 with one parameter `words`, which on this invocation is assigned the string `"hi there"`.

Within the body of the definition, the `Kernel#block_given?` method is used as an `if` condition; if a block has been passed to the method, we `yield` to it. Since we passed a block, execution jumps to the block defined on lines 8-10.

Within the block definition body, on line 9, we pass the string `'clear'` to the `Kernel#system` method. The `Kernel#system` method issues the `clear` command to the shell, which clears the terminal screen, returning `true` (assuming the command was successful). This is the last evaluated expression in the block and so forms the return value.

Back in the method definition, on line 4, we concatenate `words` to the string `"> "` and passed the new string so formed to the `Kernel#puts` method, which outputs it to the screen: `"> hi there"`. `puts` returns `nil` as always, and since this is the last expression in the method definition, the `say` invocation also returns `nil`.



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

The entity on lines 1-6 is a method definition and its author occupies the role of method implementor.

The entity on lines 8-10 is a method invocation with a block, and its author occupies the position of method user.

The `increment` method is invoked on line 8 with the integer `5` passed as argument, and a block, defined over lines 8-10, passed as implicit argument. The block is defined as part of the method invocation and is implicitly passed to the `increment` method call.

The `increment` method is defined over lines 1-6 with one parameter `number` which on this invocation is assigned the integer argument `5`.

Within the method definition body, on line 2, the `Kernel#block_given?` method is invoked as an `if` condition. Since we have passed a block to the method, `block_given?` returns `true`, and we enter the `if` control flow branch on line 3. We invoke the `yield` keyword, which calls the block, passing the integer return value of `number + 1`, which is `6`, as argument.

Execution jumps to the block definition on line 8, where the integer `6` is assigned to the block parameter `num`. In the body of the block, on line 9, `num` is passed to the `Kernel#puts` method, which outputs `6` to the screen and returns `nil`, since it always returns `nil`. This is the last expression in the block, so the block also returns `nil`.

Back in the method definition on line 5, we again add `1` to `number`, and since this is the last expression in the method definition, this `increment` call returns `6`.



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

---this is too much meaningless detail for the question----

On line 14, the first executed line, we call the `compare` method with the string `"hello"` and the Symbol `:upcase` passed as arguments.

The `compare` method is defined on lines 1-12 with two parameters, `str`, which on this invocation is assigned the string `"hello"`, and `flag`, which on this call is assigned the Symbol `flag`.

Within the method definition body, on line 2, the `after` method-local variable is initialized to the object returned by a `case` statement, which extends over lines 2-8.

The `case` statement checks the value of the `flag` variable against two `when` clauses: `:upcase` and `:capitalize`. Since we passed `:upcase` to the `flag` positional parameter, we enter the branch on line 4. Here, we call the `String#upcase` method on `str`, and since this is the last evaluated expression in the branch, the resulting string `"HELLO"` forms the return value of the case statement, which is assigned to `after`.

Next, on line 10, we interpolate `str` into the string `"Before: #{str}"` and pass the interpolated string to `Kernel#puts`, which outputs `"Before: hello"`. On line 11, we interpolate `after` into the string `"After: #{after}"` and pass the return value to `puts` to be output: `"After: HELLO"`.

--- instead do something like ---

The `compare` method is defined on lines 1-12. We have designed this method to implement a sandwich code pattern, where we print a string passed to the method, perform some intervening action on it, and then print the result. The `Kernel#puts` call on line 10 represents the 'before' action, and the `puts` statement on line 11 represents the 'after' action. The intervening operation is actually performed by the `case` statement on lines 2-8 and the result is used to initialize the `after` method-local variable.

What intervening action is taken between the 'before' and 'after' steps is limited to a fixed number of options determined by the `case` statement. As we can see from the invocation example on line 14, the user passes a String to the first positional parameter `str`, and then a Symbol representing the operation to the second parameter `flag`. The `case` statement on lines 2-8 checks the reference of `flag` against predetermined options: `:upcase` or `:capitalize`. In our example, the Symbol `:upcase` has been passed at invocation time, so the branch on line 3 is followed, and on line 4 we call `String#upcase` on `str` and this forms the return value of the `case` statement which is assigned to `after`.

The problem with this method design is how limited our choice of intervening actions are. The method can only perform a certain number of predetermined actions in between the 'before' and 'after' steps. The method implementor cannot possibly anticipate all the ways in which someone might need to use the method. And the user may find this method too narrowly conceived to be of use.

Ruby gives us a great deal more flexibility when writing sandwich code methods. We can use defer the intervening action to a block, and then the method user can decide what action to perform on the string on an ad hoc basis when they call the method:

```ruby
def compare(str)
  puts "Before: #{str}"
  after = yield(str) if block_given?
  puts "After: #{after}"
end

compare("hello") { |string| string.upcase }
```

Now the method user is not limited to a fixed number of actions they can perform on the string; they only need to know that the method will print their string, pass the string to the block, and then print the return value of the block. Blocks allow the method implementor to defer part of the implementation to the point of invocation, allowing the method user to refine the method implementation for each individual use case, without modifying the method for other users.









16. What does this code output and why? How is the block being used?

```ruby
def compare(str)
  puts "Before: #{str}"
  after = yield(str)
  puts "After: #{after}"
end

compare('hello') { |word| word.upcase }
```

The `compare` method defined on lines 1-5 is written in a generic way to defer part of the implementation to the method user at the time of invocation. It also implements a very basic sandwich code pattern; it prints the String passed as argument (line 2), `yield`s to the block (line 3), and then prints the return value of the block (line 4).

On line 7, we invoke the `compare` method with the string `'hello'` passed as argument, and the block `{ |word| word.upcase }` passed implicitly to the invocation.

Within the method definition (lines 1-5), the parameter `str` is assigned the string `'hello'`. In the body, on line 2, we interpolate `str` into a string and pass the interpolated string to `Kernel#puts` to be output to the screen: `"Before: hello"`.

Next, on line 3, we initialize the method-local variable `after` to the return value of the `yield` keyword with `str` passed as argument. `yield` calls the block and passes `str` as argument.

Execution jumps to the block defined on line 7. Block parameter `word` is assigned the string `'hello'`. In the body of the block, we call `String#upcase` on `word`, returning `"HELLO"`. This is the last expression in the block and so forms the return value assigned to `after` back in the method definition on line 3.

On line 4, we interpolate `after` into a string and pass the resulting string to `puts` to be output: `"After: HELLO"`.

This example demonstrates the main use cases for blocks when writing a method: to defer part of the implementation to invocation time, allowing the user to refine the implementation to their use case, and here more specifically, to implement a sandwich code pattern which performs 'before' and 'after' steps around the execution of the block.



17. What does this code do? What use case of blocks does the `time_it` method represent?

```ruby
def time_it
  time_before = Time.now
  yield
  time_after= Time.now

  puts "It took #{time_after - time_before} seconds."
end

time_it { sleep(3) }
```

On line 9, we call the `time_it` method with a `{ ... }` block.

The `time_it` method is defined on lines 1-7. Within the body of the definition, on line 2, we initialize method-local variable `time_before` to a new Time object which represents the time at the moment it is instantiated with `Time.now`. We can see this as a 'before' action, given what happens on the next two lines.

On line 3, we `yield` to a block, which on this invocation is the block defined on line 9.

Execution jumps to the block defined on line 9, which calls the `sleep` method with `3` passed as argument. This pauses the program for three seconds.

Execution returns to the `time_it` method, on line 4, where we initialize method-local variable `time_after` to the Time object returned by a second call to `Time.now`. We can seen this as an 'after' action, along with the next line, line 6.

On line 6, we interpolate the return value of subtracting `time_before` from `time_after` into a string, which we pass to `Kernel#puts`. The output will approximate `"It took 3.0 seconds"`.

`time_it` makes use of an implicit block to implement a sandwich code method. The method takes the time before *something* happens, calls the block with `yield`, and then takes the time after that *something* happens and outputs how long that *something* took. What the intervening *something* actually is has been left entirely to the method user. The use of a Ruby block has allowed the method implementor to write a very flexible and generic benchmarking method that will report how long any code passed to it in the block takes to execute.

This example demonstrates a significant use case of blocks for method implementors; specifically, it demonstrates how a block can be used to implement a sandwich code method.

11m18s





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

In code example `a)`, we initialize local variable `file` to the File object returned to a call to `File::open` without a block. At this point, the File object is open and we must remember to close it manually to avoid leaking file handles, which for the duration of a process are a finite system resource.

On line 2, we write the string `"Four score and seven years ago"` to `file`, using `File#write`.

On line 3, we remember to close `file` with `File#close`.

In code example `b)`, we again call `File::open` on line 1, but this time we do so with a block. The `File::open` method passes the new File object into the block to be assigned to block parameter `file`. We then perform the same `File#write` operation as above on line 2 on the block-local variable `file`, and the block definition ends with the `end` keyword on line 3.

When called with a block, the `File::open` method passes the file we have opened into the block to be assigned to the block parameter. This block-local variable, in this case `file`, can be used for the duration of the block, and then when the block returns, the `File::open` method closes the file we have opened for us, freeing the system resource associated to it.

This use of a block is a 'sandwich code' pattern which is extremely useful, especially in relation to system resources. The use of `File::open` with a block demonstrated in `b)` has the advantage over `a)` in that we do not need to remember to keep track of and close the file ourselves. The File object will be closed at the same time that the block-local variable referencing it goes out of scope. The use of blocks with the `File::open` method turns it into a flexible, generic sandwich code method that abstracts away the need to open, keep track of, and then close a file, while giving the method user the freedom to manipulate the file in the block in whatever way they see fit.

This example demonstrates one of the key use cases of blocks; specifically, it demonstrates the way Ruby blocks allow method implementors to write sandwich code methods.

10m38s





19. What is happening in the first line of the code below? What will the output of the `test` method call be?

```ruby
def test(&block)
  puts "What's &block? #{block}"
end

test { sleep(1) }
```

On line 5, we call the `test` method with a `{ ... }` block.

The `test` method is defined on lines 1-3 with one parameter, `block`. The `&` operator that prefixes the `block` parameter in the parameter list denotes that `block` is an explicit block parameter.

The use of `&` in this context allows us to explicitly manipulate the block as an object, by converting a given block to an ordinary Proc object. Thereafter, we can call the Proc with `Proc#new` but also pass it around like any other object. This makes the block passed to the method a first-class citizen, rather than the more spectral presence of an implicit block. An implicit block can only be interacted for the duration of the method call on which it has been defined. We can check for an implicit block with `Kernel#block_given?` or we can `yield` to it, but we cannot assign it to a variable or pass it around, since it is not an object.

On line 2, we confirm the class of the object produced by the explicit block parameter by interpolating `block` into a string and passing it to `Kernel#puts`. `puts` will output something approximate to:

`"What's &block? #<Proc:0x00007f05564fa300 /home/nicholas/launch_school/rb130/scratch.rb:5>">`

This example demonstrates the use of explicit block parameters to convert a block passed to a method to a Proc object assigned to a method-local variable.

7m05



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

On line 13, we call the `test` method with a `{ ... }` block.

The `test` method is defined on lines 7-11 with one parameter, `block`. Prefixed to the `block` parameter is the `&` operator, which in this context signifies that `block` is an explicit block parameter. The given block is converted to a Proc object and assigned to the method-local variable `block`. Thereafter, we can call `block` with `Proc#call` but also pass `block` around like any other object. Using an explicit block parameter converts the block to a first-class citizen, unlike the more spectral presence of an implicit block; an implicit block can be interacted with using `yield` and `Kernel#block_given?` but only from within the method call on which it is defined.

Within the `test` method definition body, on line 9, we pass the string `"1"` to the `Kernel#puts` method, which prints it to the screen. On line 10, we call the `test2` method, passing the `block` Proc object as argument.

The `test2` method is defined on lines 1-5 with one parameter `block`. Unlike the parameter of `test`, this `block` parameter is not prefixed with `&` and so takes an object rather than an explicit block. On this invocation, `block` is assigned to the Proc object produced by the explicit block parameter of the `test` method out of the block passed to that method. The advantage of an explicit block parameter is precisely that we can pass the resulting Proc around like this.

Within the body of the `test2` method, on line 2, we pass the string `"hello"` to `puts` to be output. On the next line, we call `Proc#call` on `block`.

Execution jumps to the code defined by the block definition on line 13. We pass the string `"xyz"` to `puts`, which is output to the screen.`puts` always returns `nil`, and since this is the last expression in the Proc, the Proc also returns `nil`.

Back in the `test2` method, on line 4, we pass the string `"good- bye"` to `puts`, which is output to the screen. `puts` returns `nil` and since this is the last expression in the `test2` definition, `test2` also returns `nil`.

Back in the `test` method, on line 10, we pass the string `"2"` to `puts`, which outputs it to screen and returns `nil`. This forms the return value of `test`.

This example demonstrates how explicit block parameters convert a given block to a Proc object. It also shows that if we pass the resulting Proc to another method, we pass it like any other object, without an explicit block parameter in the receiving method.

13m01



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

On line 11, we call the `test` method with a `{ ... }` block.

The `test` method is defined on lines 5-9 with one parameter `block`. The parameter is prefixed with the `&` operator, which in this context signifies that `block` is an explicit block parameter.

An explicit block parameter must be the last parameter in the list. The given block is converted to a Proc object and assigned to method-local variable `block`. Thereafter, the Proc can be passed around to other methods like any other object. The parameter is just a method-local variable like other parameters, can be reassigned, and is not referred to using `&` except in the parameter list.

Within the body of the `test` method definition, on line 6, we pass the string `"1"` to `Kernel#puts`, which outputs it to the screen. Next, on line 7, we call the `display` method with `block` passed as argument.

The `display` method is defined on lines 1-3 with one parameter `block`, which on this invocation is assigned the Proc object produced by the explicit block parameter of the `test` method. It is important to note that a Proc is simply another object, so the `block` parameter of the `display` method is not preceded by `&` in the parameter list. It is an ordinary parameter.

Within the body of the `display` method definition, on line 2, we call `Proc#call` on `block` with the string `">>>"` passed as argument.

Execution jumps to the Proc's code, defined by the block definition on line 11. The string `">>>"` is assigned to the block parameter `prefix`. Within the body of the Proc's code, we concatenate `prefix` to the string `"xyz"` and pass the new concatenated string to `puts`. This outputs `">>>xyz"`, and `puts` returns `nil` as it always does. This forms the return value of the Proc.

Execution jumps back to the `display` method, and since there is no more code, `display` also returns `nil`.

Back in the `test` method on line 8, we pass the string `"2"` to `puts`, which outputs it to screen and returns `nil`. This forms the return value of the `test` method.

This example demonstrates how we can use an explicit block parameter to convert a given block to a Proc object, which can be passed to other methods like any other object.

11m

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

On line 11, we call the `#times` method with the integer `5` passed as argument and a `do...end` block.

The `times` method is defined on lines 1-9 with one parameter, `number`, which on this invocation is assigned the integer `5`.

Within the method definition body, on line 2, we initialize method-local variable `counter` to `0`.

On the next line we enter a `while` loop, whose condition checks that `counter` is less than `number`. Within the loop, on line 4, we `yield` to the given block with `counter` passed to the keyword as argument.

Execution jumps to the block defined on lines 11-13. The current value of `counter` is assigned to the block parameter `num`. Within the block body, on line 12, we pass `num` to the `Kernel#puts` method, which outputs the integer to screen. `puts` returns `nil` as it always does and since there is no more code in the block, the block also returns `nil`, though nothing is done with it.

Execution jumps back to the method definition. On line 5, we increment `counter` by `1`. The loop continues (on this `times` invocation) until `counter` references `5`.

On line 8, we restate `number` as the implicit return value of `times`, which on this call is `5`.

This code will therefore output:

```
0
1
2
3
4
```

This example demonstrates the implementation of a method similar to `Integer#times`.

6m40s

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

