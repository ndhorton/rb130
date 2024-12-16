

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

On line 12, we call the `each` method with an array, `[1, 2, 3, 4, 5]`, passed as argument and a `do...end` block.

The `each` method is defined on lines 1-10 with one parameter `array`, which on this invocation is assigned the array `[1, 2, 3, 4, 5]`.

Within the body of the method definition, on line 2, we initialize method-local variable `counter` to `0`.

On line 4, we enter a `while` loop, which continues while `counter` is less than the size of `array`.

Within the loop, on line 5, we `yield` to the given block with the element of `array` at the index given by `counter` passed as argument.

Execution jumps to the block defined over lines 12-14. The current `array` element is assigned to block parameter `num`.

Within the body of the block, on line 13, we pass `num` to `Kernel#puts` to be output to the screen. `puts` returns `nil` as it always does and since this is the end of the block, the block also returns `nil`, though nothing is done with it.

Execution resumes on line 6 of the `each` method definition, where we increment `counter`. The loop continues until `counter` references `5`.

On line 9, we restate `array` as the implicit return value of `each`.

This example demonstrates a simple implementation of a method similar to `Array#each`.





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
```

On line 14, we initialize local variable `array` to the array `[1, 2, 3, 4, 5]`. On line 16, we call the `select` method, passing `array` as argument, with a `{ ... }` block.

The `select` method is defined over lines 1-12 with one parameter `array`, which on this invocation is assigned the `[1, 2, 3, 4, 5]` array.

Within the definition body, we initialize method-local variable `counter` to `0`. We then initialize `result` to an empty array.

On line 5, we enter a `while` loop, which loops while `counter` is less than the size of `array`.

On line 6, we initialize `current_element` to the element of `array` at index `counter`.

On line 7, an `if` statement in modifier form uses the block as a boolean conditional. We `yield` to the block with `current_element` passed as argument. If the object returned by the block is truthy, we push `current_element` to the `result` array; if the object is `false` or `nil`, we do not.

Execution jumps to the block defined on line 16. Block parameter `num` is assigned the integer currently referenced by `current_element`. Within the body of the block, we call `Integer#odd?` on `num`. The boolean return value of `odd?` is the last evaluated expression in the block, and so forms the return value.

Execution returns to the method definition on line 7. The block will return `true` when `current_element` is an odd integer and the integer will be push to `result`; when the integer is even, the block returns `false` and the element is not pushed to `result`.

On line 8, `counter` is incremented.

After the loop, we restate `result` as the implicit return value of `select`.

This invocation of `select` will therefore return the array `[1, 3, 5]`, the odd integers from the array passed as argument.

This example demonstrates a simple implementation of a method similar to `Array#select`. It shows one of the main use cases of blocks for method implementors, to defer part of the implementation to the method user at invocation time, making for flexible, generic, and powerful methods.

9m14s

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

On line 5, we call the `increment` method with integer `2` passed as argument and a `{ ... }` block. The return value will be passed to `Kernel#p` to be output to screen.

The `increment` method is defined on lines 1-3 with one parameter `x`, which on this invocation is assigned `2`. Within the body of the method, we add `1` to `x`, returning `3`, and since there is no other code in the method, `increment` returns `3` on this call.

Back on line 5, `3` is passed as argument to `p`, and `3` is output to the screen. `p` returns its argument, `3`.

We have passed a block to a method that does not make use of a block with keyword `yield`. This does not raise an exception because any method in Ruby can accept a block argument even if the definition does not make use of it. If we pass a block to a method, like `increment`, whose implementation does not make use of a block, the method simply ignores it, without raising an exception.

4m59





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



On line 1, we initialize local variable `level_1` to the string `"outer-most variable".

Next, on line 3, we call the `Array#each` method on the array `[1, 2, 3]` with a `do...end` block that is defined over lines 3-9. The `each` method iterates through the array, `yield`ing each element in turn to the block to be assigned to block parameter `n`.

A block is one way that Ruby implements closures. A closure is a general programming concept that allows programmers to save a "chunk of code" (which we can think of as an anonymous function or method) to be passed around and executed later. A closure binds to the surrounding artifacts (such as local variables) at the point in our program where the closure is defined, "closing over" the surrounding context that the code chunk needs in order to be executed later.

We can think of closures as like anonymous methods, or anonymous functions, but with an environment attached, which in Ruby is called the closure's "binding". 

Within the `each` block, on line 4, we initialize block-local variable `level_2` to the string `"inner variable"`. This variable is local to the block and will not be accessible in the scope where the block is defined. So we could describe the original scope, where `level_1` was initialized, as the "outer scope". In this "inner scope" of the block, however, the "outer scope" local variable `level_1` is accessible, because the block has access to in-scope local variables through its binding. It retains access to `level_1` even though the `each` method has its own scope, and it is the `each` method that actually calls the block. Again, this is because the block, as a closure, has bound the `level_1` variable.

Next, on line 6, we call `each` again with a block, this time on the array `['a', 'b', 'c']`. `each` iterates through this array passing each element to the block to be assigned to the block parameter `n2`.

Within this second "innermost" or "level 3" block, we have access to both `level_1` and `level_2` through the block's binding. Since local variables `level_1` and `level_2` are in scope and initialized when the block is created, the block can bind them for access within this "innermost" block.

When we initialize a block-local variable `level_3`, on line 7, to the string `"inner-most variable"`, this variable is local to the "innermost" block. It cannot be accessed from the outer `each` block or from the original scope.

This example demonstrates how blocks create "inner" scopes where "outer scope" local variables can be accessed but whose block-local variables cannot be accessed from the "outer scope" because blocks are closures that bind in-scope artifacts such as local variables and retain access to them. It is important to note that blocks retain access to the local variables themselves, not only the values that the variables reference.

14m16s



<u>Arity of Blocks and Methods</u>



25. Will the code below raise an error? Why, or why not?

```ruby
def test
  yield(1, 2)
end

test { |num| puts num }
```

On line 5, we call the `test` method with `{ ... }` block.

The `test` method is defined over lines 1-3. Within the body of the block, we use keyword `yield` to call the given block with the integers `1` and `2` passed as arguments.

Execution jumps to the block defined on line 5, where block parameter `num` is assigned to the first argument passed, `1`. Although we passed a second argument, the block simply ignores it.

The reason this does not raise an `ArgumentError` exception, as a method would if called with too many arguments, is because blocks (and Procs) have "lenient arity" with respect to their arguments. This means that we can pass too many arguments and the block will simply ignore them. If we pass too few arguments, the parameters that have no corresponding argument will simply be assigned `nil`. 

The differing arity of blocks and methods means that methods enforce the count of required parameters in their parameter list with respect to the arguments passed when they are called, and blocks do not.

Within the body of the block, we pass `num` to `Kernel#puts` which outputs `1` to screen and returns `nil`. Since this is the end of the block, the block also returns `nil`.

Execution resumes in the method on line 2. There is no more code in the method definition either, so the method also returns `nil`.



26. Will the code below raise an error? Why or why not?

```ruby
def test
  yield(1)
end

test do |num1, num2|
  puts "#{num1} #{num2}"
end
```

On line 5, we call the `test` method with a `do...end` block.

The `test` method is defined on lines 1-3. Within the body of the definition, we use the `yield` keyword to call the block with integer `1` passed as argument.

Execution jumps to the block defined over lines 5-7 with two block parameters `num1` and `num2`. `num1` is assigned to the argument `1`, while `num2` has no corresponding argument and is therefore assigned `nil`.

The reason no exception is raised is that blocks have lenient arity with respect to their arguments. Unlike a method, which has strict arity, a block will not raise an exception regardless of how many or how few arguments are passed. If the block receives too many arguments for its parameters, the excess arguments are simply ignored. If the block receives too few arguments, any parameters without corresponding arguments are assigned `nil`. Methods have strict arity, meaning they enforce the exact count of arguments with respect to their required parameters.

Within the body of the block, on line 6, we interpolate `num1` and `num2` into a string, `"#{num1} #{num2}"`, and then pass the resulting string to `Kernel#puts`. Since string interpolation calls `to_s` on the objects interpolated, and `NilClass#to_s` returns an empty string, the text output will be `"1 "`.



27. Will the code below raise an error? Why, or why not?

```ruby
def process_number(num, &block)
  block.call(num)
end

process_number(7) { |num1, num2| num1 ** num2 }
```

On line 5, we call the `process_number` method with integer `7` passed as argument and a `{ ... }` block.

The `process_number` method is defined over lines 1-3 with two parameters. On first glance, it may seem that we have passed too few arguments, in which case the method would raise an `ArgumentError`. However, this is not the case. The first parameter, `num`, is assigned to `7` on this invocation. The second `block` is prefixed with the `&` operator in the parameter list on line 1, signifying that `block` is an explicit block parameter. 

The `&` operator prefixed to a method parameter will convert a given implicit block argument to a Proc object and assign it to the parameter. Thereafter, the Proc can be passed around, returned, and generally treated like any other object. The explicit block parameter itself is just another parameter, which can be reassigned like any other local variable. The explicit block parameter variable is not referenced with a `&` inside the body of the method definition, only in the parameter list.

Within the body of the method definition, on line 2, we call  the `Proc#call` method on `block` with `num` passed as argument.

Execution jumps to the code defined by the block definition on line 5. There are two block parameters. The first, `num1`, is assigned to the argument passed by the `process_number` method, the integer `7`. The second parameter, `num2`, has no corresponding argument and so it is assigned `nil`.

Blocks, unlike methods, have 'lenient arity'. This means that a block does not enforce the count of arguments suggested by its parameters. If we pass too few arguments, the block parameters without an argument are assigned `nil`. If we pass too many arguments, the excess arguments are simply ignored. Methods have 'strict arity', meaning that methods enforce the number of arguments called for by their required parameters and will raise an `ArgumentError` exception if we pass too few or too many.

Within the body of the block, we attempt to raise `num1` to the power given by `num2` using the `**` operator method. This raises an exception because `num2` has been assigned `nil` and the `Integer#**` method requires a Numeric argument.

This example demonstrates the different arity of blocks compared to methods. It also demonstrates the use of an explicit block parameter that allows us to assign an implicit block argument to a parameter by converting the block (a structure of code) to a Proc (an object).



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

On line 5, we initialize local variable `arr` to an array, `[1, 2, 3, 4, 5]`. On line 6, we initialize local variable `results` to the array `[0]`.

Next, on line 8, we call the `for_each_in` method with `arr` passed as argument, implicitly passing a block defined over lines 8-11.

A block is one of the ways Ruby implements a closure. A closure is a general programming concept that allows programmers to save a "chunk of code" (which we can think of as an anonymous function or method) to be passed around and executed later. A closure binds to the surrounding artifacts (such as local variables) at the point in our program where the closure is defined, "closing over" the surrounding context that the code chunk needs in order to be executed later.

We can think of closures as like anonymous methods, or anonymous functions, but with an environment attached, which in Ruby is called the closure's "binding". A closure will bind the in-scope local variables initialized before the closure is created.

The `for_each_in` method is defined on lines 1-3 with one parameter, `arr`, which on this invocation is assigned the array referenced by the `arr` local variable initialized on line 5, which we passed as argument to the method. The `arr` parameter is a method-local variable and is not the same variable as the one passed as argument, they simply have the same name and on this invocation point to the same object. This is not a case of variable shadowing either, since methods have self-contained scope with respect to local variables.

Within the body of the method definition, on line 2, we call the `Array#each` method on method-local variable `arr` with a `{ ... }` block. The `each` method iterates through each element of `arr`, passing each in turn to the block to be assigned to block parameter `element`. Within the body of the block, we `yield` to the block passed to the `for_each_in` method with `element` passed as argument.

When we use keyword `yield` in the context of the `for_each_in` method, execution jumps to the block defined on lines 8-11, where the current `element` integer is assigned to the block parameter `number`. 

Within the body of the block, we initialize block-local variable `total` to the return value of adding `number` to the element at index `-1` of the `results` array. This is the same local variable initialized on line 6. We are able to access it because the block bound the `results` local  variable when it was created. This is why we are able to mutate the `results` array on line 10, where we `push` block-local variable `total` to the end of the `results` array. Since `results` was initialized in the same scope (top-level) before (line 6) the block was created (line 8), the block can access `results` and the object it references, and we could even reassign the `results` variable to reference a different object if we wished. 

Even though the block is called from the self-contained local variable scope of `for_each_in`, the block on lines 8-11 can access the `results` variable from the scope in which it was created through its binding, even though the `for_each_in` method cannot access the `results` variable.

This is why, when we pass `results` to `Kernel#p` on line 13, after `for_each_in` returns, the output will be `[0, 1, 3, 6, 10, 15]`.

This example demonstrates local variable scope with respect to blocks; specifically, it demonstrates that, as a form of Ruby closure, a block will bind the in-scope local variables that it requires in order to execute, and retains access to those local variables through its binding, even though the block is executed from a different scope (the method scope where `yield` is used).



32. Will this code raise an error? Why, or why not?

```ruby
def call_me(some_code)
  some_code.call
end


chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"

call_me(chunk_of_code)
```

On line 6, we initialize local variable `chunk_of_code` to a new Proc object, passing a `{ ... }` block to `Proc::new`.

On the next line, line 7, we initialize local variable `name` to the string `"Griffin III"`. Although we are still in the same lexical scope for local variables (top-level), the Proc we just created will not bind to the `name` local variable since it was initialized after the Proc was instantiated.

A Proc is one of the ways Ruby implements a closure. A closure is a general programming concept that allows programmers to save a "chunk of code" (which we can think of as an anonymous function or method) to be passed around and executed later. A closure binds the chunk of code to the surrounding artifacts (such as local variables) at the point in our program where the closure is defined, "closing over" the surrounding context that the code chunk needs in order to be executed later. We can think of closures as like anonymous methods, or anonymous functions, but with an environment attached, which in Ruby is called the closure's "binding".

Closures bind to the local variables in scope at the time and location in the program where the closure is created. A local variable must be initialized before the closure is created for the closure to bind it.

On line 9, we call the `call_me` method, with `chunk_of_code` passed as argument. The `call_me` method is defined on lines 1-3 with one parameter `some_code`, which on this invocation is assigned the `chunk_of_code` Proc. Within the body of the method definition, on line 2, we call `Proc#call` on `some_code`.

Execution jumps to the code defined by the block definition on line 6. We attempt to interpolate `name` into a string. Since we cannot access the `name` local variable from line 7, since it was initialized after the Proc was created, and there is no other `name` variable or method definition in the code example, a `NameError` exception is raised.

This example demonstrates local variable scope with respect to a Proc and its binding; specifically, it demonstrates that a Proc will only bind local variables initialized in-scope before the Proc is created.



<u>Methods with an Explicit Block Parameter</u>

36. What is the object referenced by method-local variable `block` and where does it come from?

```ruby
def test(&block)
  puts "What's &block? #{block}"
end

test { sleep 1 }
```

On line 5, we call the `test` method, passing a `{ ... }` block as implicit argument to the method invocation.

The `test` method is defined on lines 1-3 with one parameter `&block`. The `&` prefix denotes that this is an explicit block parameter.

Every method, regardless of its definition, can take an block as an implicit argument, even if the method definition does not make use of it with the `yield` keyword. However, a method can instead take the block as an explicit argument, denoted in the method definition by an `&` prefixed to the last parameter in the parameter list.

The `&` operator prefixed to a method parameter will convert a given implicit block argument to a Proc object and assign the Proc to the parameter. Thereafter, the Proc can be passed around, returned, and generally treated like any other object. The explicit block parameter itself is just another parameter, which can be reassigned like any other local variable. The explicit block parameter variable is not referenced with a `&` inside the body of the method definition, only in the parameter list.

If no block is given when the method is invoked, the explicit block parameter will be assigned `nil`, so we may wish to test for this before invoking Proc methods on it.

The advantages of an explicit block over an implicit block are the advantages of a first-class citizen, an object, which can be passed around to other methods. This is more flexible than the more spectral presence of an implicit block, which can only be interacted with or executed only from within the method to which the block is implicitly passed .

So in this example, the block defined on line 5 and passed implicitly to the `test` method is converted to a Proc object that is assigned to the `block` method-local variable.

Within the body of the method definition, we interpolate `block` into the string `"What's &block? #{block}"` and pass the resulting string to the `Kernel#puts` method, which outputs something similar to

```
What's &block? #<Proc:0x00007f7eaf02a348 /home/nicholas/launch_school/rb130/scratch.rb:5>
```

This example demonstrates methods that take an explicit block parameter.



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

On line 13, we call the `test` method with a `{ ... }` block.

The `test` method is defined on lines 7-11 with one parameter `&block`. The `&` prefixed to the name of the parameter denotes that this is an explicit block parameter.

The `&` operator used in this context converts the block passed to the method into a Proc object. Thereafter, the resulting Proc can be passed around like any other object. An implicit block remains accessible only to the method invocation on which it is defined; a block is a code structure rather than an object, a first-class citizen. An explicit block parameter allows us to treat the block as an object, by converting it to a Proc.

An explicit block parameter is referenced within the method body without the `&`. If no block is passed to the method, the explicit block parameter is simply assigned `nil`.

Within the `test` method, we output `"1"` with the `Kernel#puts` method and then call the `test2` method with `block` passed as argument. This is only possible because we have used an explicit block parameter. An implicit block argument cannot be passed forward to another method call (or returned), since it is not an object.

The `test2` method is defined on lines 1-5, with one parameter `block`, which on this invocation is assigned the Proc created by the explicit block parameter of the `test` method. The `block` parameter of the `test2` method is just a simple positional parameter. Since a Proc is an object like any other, we do not need an explicit block parameter to pass it to.

Within the body of the `test2` method, we output the string `"hello"` with the `puts` method on line 8. On the next line, line 9, we call `Proc#call` on `block`.

Execution jumps to the code defined by the block definition on line 13. The Proc parameter is assigned `nil`, since we did not pass an argument to `Proc#call`. Within the body of the Proc, we output the string `"xyz"` with `puts`.

Execution resumes in the `test2` method, where we output `"good-bye"` with `puts` on line 10.

Execution resumes in the `test` method, where on line 10, we output `"2"` with `puts`.

This example demonstrates methods with an explicit block parameter; specifically, it shows that an explicit block parameter allows us to pass the block to another method as a Proc object, which we cannot do with an implicit block.



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

On line 11, we call the `test` method with a `{ ... }` block.

The `test` method is defined on lines 5-9 with one parameter `&block`. The `&` prefix denotes that this is an explicit block parameter.

An implicit block can only be interacted with by the method on whose invocation the block is defined. By using an explicit block parameter, which converts the block passed to the method to a Proc object and assigns the Proc to the parameter, we can pass the closure around to other methods, as we might any other object. The `&` prefix is only used in the parameter list; thereafter in the method body, we reference the parameter without it, like any other method-local variable.

Within the body of the method, we pass the string `"1"` to `Kernel#puts` to be output to screen. On the next line, line 7, we call the `display` method with `block` passed as argument.

The `display` method is defined on lines 1-3 with one parameter `block`, which on this invocation is assigned the Proc object resulting from the explicit block parameter in the `test` method. Since a Proc is an object like any other, we do not need an explicit block parameter with the `&` operator to accept it.

Within the body of the `display` method, on line 2, we call `Proc#call` on `block` passing the string `">>>"` as argument.

Execution jumps to the code defined by the block definition on line 11. The Proc parameter `prefix`  is assigned the string we passed as argument. Within the body of the block, we concatenate `prefix` to the string `"xyz"` and pass the resulting string to the `puts` method to be output. `puts` returns `nil` as it always does, and since there is no more code the block also returns `nil`.

Execution resumes in the `display` method. There is no more code here either, so `display` also returns `nil`, though nothing is done with it.

Back in the `test` method, on line 8, we pass the string `"2"` to `puts` to be output. `puts` returns `nil` and this is the last evaluated expression in the `display` method, so `display` also returns `nil`.

Therefore this code outputs

```
1
>>>xyz
2
```

This example demonstrates methods with an explicit block parameter; specifically, it shows that an explicit block parameter allows us to pass the block to another method as a Proc object. Passing an implicit block in this fashion is impossible, so for some use cases an explicit block parameter is necessary.





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

