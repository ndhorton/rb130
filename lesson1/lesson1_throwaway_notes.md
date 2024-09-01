## RB130 Summary and Syllabus

This course will cover some language specific aspects of the Ruby programming language. We'll specifically look at blocks and the Minitest testing library. This course will include assignments that will build upon knowledge gained from previous courses. After this course, you should have a deeper understanding of blocks and how to use Minitest.

### **Blocks**

- **Closures in Ruby**
- **Calling methods with blocks**
- **Writing methods that take blocks**
- **Build a "times" method from scratch**
- **Build an "each" method from scratch**
- **Build an "select" method from scratch**
- **Build an "reduce" method from scratch**
- **Build a todo list**
- **Blocks and variable scope**
- **symbol to proc**

### **Introduction to Testing**

- **Setting up Minitest**
- **Introduction to Minitest**
- **Assertions and refutations**
- **The general approach for testing**
- **Testing equality**
- **Write your first test suite**
- **Code and test coverage**



### New methods, classes and keywords

* `yield` keyword - execute a block passed as implicit argument to the current method invocation
* `Kernel#block_given?` - returns `true` if a block has been passed to the current method invocation as implicit argument, `false` otherwise
* `Proc#call`
* `&`
* `Proc.new { ... }`
* `Symbol#to_proc`
* `require 'minitest/autorun'` - access to the Minitest facilities
* `require 'minitest/reporters'` - adds color test results
* `require_relative` -- loads file relative to directory of current file (rather than looking in Ruby installation directories). We need to require the files containing the classes and modules we wish to test
* `Minitest::Test` - Minitest test classes subclass from this class
* `assert_equal` - Minitest assertion method inherited through `Minitest::Test`
* `Minitest::Reporters.use!` - activates color test results
* `skip` - Minitest keyword, skip a test
* `describe` - begins block of spec-style tests. Minitest spec DSL
* `it` - begin an expectation block
* `_(` method call `).must_equal` -  sets an expectation
* `Minitest::Assertions` - docs for this module give full list of assertions in Minitest
* `assert(test)` - fails unless `test` is truthy
* `assert_equal(exp, act)` - fails unless `exp == act``
* ``assert_nil(obj)` - fails unless `obj.nil?`
* `assert_raises(*exp) { ... }` - fails unless block raises one of `*exp``
* ``assert_instance_of(cls, obj)` - fails unless `obj` is an instance of `cls`
* `assert_includes(collection, obj)` - fails unless collection includes `obj`

### Structure

Lesson 1:

- 1.1: Introduction
- 1.2: Closures in Ruby: first definition of closure
- 1.3: Calling methods with blocks: blocks as arguments
- 1.4: Writing methods that take blocks: blocks as peculiar arguments, `yield`ing, blocks and arguments, arity, blocks vs methods, block return values, use cases of methods with blocks, generic methods, sandwich code, resource management, `File::open` with block, file handles/objects automatically closed when block returns, `&`, methods with explicit block parameters, block-to-simple-proc conversion, `Proc#call`, more on closures
- 1.5: Build a `times` method: more detail on the use cases of blocks from implementation and user povs
- 1:6: Build an `each` method: more about use cases of blocks from implementor and user povs
- 1:7: Build a `select` method: etc
- 1:8: Build a `reduce` method: mostly about `reduce`
- 1:9: TodoList: all coding
- 1:10:`TodoList#each`: encapsulation, the public interface, and class invariants
- 1:11:`TodoList#select`: mostly coding, reminder to follow conventions of Ruby library
- 1:12: and 1:13: all coding
- 1:14: Blocks and variable scope: more on closures, bindings
- 1:15: Symbol to proc:
- 1:16: Quiz: answer to Question 2: "A closure retains access to variables within its binding rather than the specific values of those variables at the time the closure was created; if the value of those variables changes, the closure accesses the new  values." This is the only useful information in the quiz.

Lesson 2:

* 2.1: Introduction: includes some jargon that is not explained. This lesson is an introduction to unit testing only.
* 2.2: Setting up Minitest: installing the minitest bundled gem
* 2.3: Lecture: Minitest: vocab, tests, results, failures, skip, reporters gem, assertions, expectations, expectation matches, assert-style vs expectation-style or spec-style
* 2.4: Assertions: list of assertions, `Minitest::Assertions`



Lesson 1.2:

A **closure** is a general programming concept. A closure allows programmers to save a “chunk of code” and execute it at a later time. It is called a closure because it’s said to bind its surrounding artifacts (names like variables and methods) and build an “enclosure” around everything so that they can be referenced when the closure is later executed. It can be useful to think of a closure as a method that you can pass around and execute, but it’s not defined with an explicit name. Different programming languages implement closures in different ways. Some languages will have first-class support for it, while other languages won’t deal with it at all.

In Ruby, a closure is implemented through 1) a `Proc` object, 2) a lambda, or 3) a block. We can pass these “chunks of code” around and execute them later. This is especially useful for passing “chunks of code” into existing methods. A closure retains references to its surrounding artifacts — its **binding**.

The three main ways to work with closures in Ruby:

1. Instantiating an object from the `Proc` class
2. Using lambdas
3. Using blocks

Lesson 1.3:

```ruby
[1, 2, 3].each do |num|
  puts num
end
```

Here, we have the object `[1, 2, 3]` on which we are calling the method `Array#each`, and the block **passed as argument** to the `each` method:

```ruby
        		do |num| 
	puts num 
end
```

**The block is an argument to the method call**. We are actually *passing in* the block of code to the `each` method invocation.



Lesson 1.3:

"Isn't passing in a block just like passing in any other argument? Not quite. **In Ruby, every method can take an optional block as an implicit argument. ** You can just tack it on at the end of the method invocation"

So a block is an implicit argument. It does not count towards the required parameters. So passing a block to a method that takes no arguments (even one that makes no use of a block) does not raise an `ArgumentError`.

<u>Yielding</u>

One way to invoke the passed-in block from within the method is to use the `yield` keyword.

If your method implementation contains a `yield`, a developer using your method can come in after this method is fully implemented and inject additional code in the middle of this method (without modifying the method implementation), by passing in a block of code. This is one of the major use cases of using blocks, which we'll talk more about later.

If we define a method that uses `yield` without checking if a block has been passed, then calling that method without passing a block as implicit argument will result in raising a `LocalJumpError` exception.

To allow us to call the method with or without a block, we must somehow wrap the `yield` call in a conditional: only call `yield` if a block is passed to the method and don't call `yield` when there's no block. We can achieve this with the `Kernel#block_given?` method. And because it's in `Kernel`, it's available everywhere.

`yield` to the block - execute the block of code

<u>Passing execution to the block</u>

The method invocation with a block is still a method invocation, not a method implementation.

```ruby
# method implementation
def say(words)
  yield if block_given?
  puts "> " + words
end

# method invocation
say("hi there") do
  system 'clear'
end # clears screen first, then outputs "hi there"
```

1. Execution starts at the method invocation on line 8. The `say` method is invoked with two arguments: a string and a block (the block is an implicit parameter and not part of the method definition). N.B. does 'method definition' here mean method/function signature? Like the name plus list of formal parameters?
2. Execution passes to line 2, where the **method local variable** `words` is assigned the string "hi there". The block is passed in implicitly, without being assigned to a variable.
3. Execution continues into the first line of the method implementation, line 3, which immediately yields to the block.
4. The block, line 9, is now executed, which clears the screen.
5. After the block is done executing, execution continues in the method implementation on line 4. Executing line 4 results in output being displayed.
6. The method ends, which means the last expression's value is returned by this method. the last expression in the method invokes the `puts` method, so the return value for the method is `nil`.

<u>Yielding with an argument</u>

```ruby
3.times do |num|
  puts num
end
```

The `num` variable between the `|`'s is a parameter for the block, or more simply, a block parameter. Within the block, `num` is a **block local variable**. The scope of `num` is constrained to the block.

Beware of variable shadowing.

Blocks are perfect for allowing some flexibility at method invocation time. Perhaps we don't know what users of the method might want to do with some value calculated by the method, output it to the screen, or to a file, or to the network. A block can let them decide exactly what they want to do with it.



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

1. Execution starts at method invocation on line 10.
2. Execution moves to the method implementation on line 2, which sets `5` to the local variable `number`, and the block is not set to any variable; it's just implicitly available.
3. Execution continues on line 3, which is a conditional.
4. Our method invocation has indeed passed in a block, so the conditional is true, moving execution to line 4.
5. On line 4, execution is yielded to the block (or the block is called), and we're passing `number + 1` to the block. This means we're calling the block with `6` as the block argument.
6. Execution jumps to line 10, where the block parameter `num` is assigned `6`.
7. Execution continues to line 11, where we output the block local variable `num`.
8. Execution continues to line 12, where the end of the block is reached.
9. Execution now jumps back to the method implementation, where we just finished executing line 4.
10. Execution continues to line 5, the end of the `if`.
11. Line 6 returns the value of the incremented argument to line 10.
12. The program ends (the return value of `#increment` is not used)



<u>Arity</u>

The rule regarding the number of arguments that you must pass to a block, proc, or lambda in Ruby is called its **arity**. In Ruby, blocks and procs have **lenient arity**, which is why Ruby doesn't complain when you pass in too many or too few arguments to a block. Methods and lambdas, on the other hand, have **strict arity**, which means you must pass the exact number of arguments that the method or lambda expects. For now, the main thing you should remember about arity is that **methods enforce the argument count, while blocks do not**.

"Arguments in Ruby are an extremely complex topic. The above description of arity glosses over this complexity and ignores things like optional arguments, variable arguments, and variable keyword arguments. Importantly, if your method or block allows any kind of optional arguments, the arity rules do not apply to those arguments."



<u>Return value of yielding to the block</u>

Blocks have return values, just like methods. The return value will be the last evaluated expression in the block. Nothing in this section about explicit `return` and the difference with methods and blocks with respect to the keyword `return`.



<u>When to use blocks in your own methods</u>

There are many ways that blocks can be useful but the two main use cases are:

1. Defer some implementation code to method invocation decision.

There are two roles involved with any method: the **method implementer** and the **method user** (note that this could be the same person/developer). There are times when the method implementor is not 100% certain of how the method will be called. Maybe the method implementor is 90% certain, but wants to leave that 10% decision up to the method user at method invocation time.

Blocks allow us to **refine** a method implementation, without actually modifying the method implementation for everyone else.

Many of the core library's most useful methods are useful precisely because they are built in a generic sense, allowing us (the code that calls the method) to refine the method through a block at invocation time.

"If you encounter a scenario where you're calling a method from multiple places, with one little tweak in each case, it may be a good idea to try implementing the method in a generic way by yielding to a block."

I'm taking the above to mean something like:

If you encounter a scenario where you're writing very similar methods with one little tweak in each case, it may be a good idea to implement them as one generic method that yields to a block.

Though I guess we might also be using one method with a bunch of hard-to-remember flag parameters like the `compare` method example, which could more legibly and naturally replaced by yielding to a block.

2. Methods that need to perform some "before" and "after" actions - sandwich code.

Sandwich code is a good example of the previous point about deferring implementation to method invocation. There will be times when you want to write a generic method that performs some "before" and "after" action.

```ruby
def time_it
  time_before = Time.now
  yield
  time_after = Time.now
  puts "It took #{time_after - time_before} seconds."
end

time_it { sleep(3) }

time_it { "hello world" }
```

Another area where before/after actions are important is in resource management, or interfacing with the operating system. Many OS interfaces require you, the developer, to first allocate a portion of a resource, then perform some clean-up to free up that resource. Forgetting to do the clean-up can result in dramatic bugs -- system crashes, memory leaks, file system corruption. Wouldn't it be great if we can automate this clean-up?

This is exactly what the `File::open` method does for us.

So

```ruby
# non-block file activity
my_file = File.open("some_file.txt", "w+")
# write to this file using my_file.write
my_file.close # need to close the file object to free file-handle at OS level
```

vs.

```ruby
# with block
File.open("some_file.txt", "w+") do |file|
  # write to this file using file.write
end # after block returns, File::open automatically frees file-handle
```

<u>Methods with an explicit block parameter</u>

NB - here 'block parameter' refers to a parameter that is assigned a block (or a proc wrapping a block) and not the parameter of a block / block local variable.

Passing a block to a method explicitly. An explicit block is a block that gets treated as a named object -- that is, it gets assigned to a method parameter so that it can be managed like any other object.

To define an explicit block, you simply add a parameter to the method definition where the name of the parameter begins with a `&` character.

```ruby
def test(&block)
  puts "What's &block? #{block}"
end
```

The `&`-prefixed parameter is a special parameter that converts the implicit block argument to what we call a "simple" `Proc` object (the exact definition of a simple `Proc` object isn't important at this time). Notice that we drop the `&` when referring to the parameter inside the method.

Like `yield`, `Proc#call` can take arguments to pass to the block/proc.

"The above discussion of explicit blocks is simplified from reality. Things get a bit more complicated if the user passes in a `Proc` object, a `lambda`, or some other object to a method that takes an explicit block. For now, you just need to know that **Ruby converts blocks passed in as explicit blocks** to **simple** `Proc` objects."

<u>Using Closures</u>

A very powerful capability in Ruby and many other languages is the ability to pass chunks of code -- closures -- around in a program. AS described earlier, **closures are formed by blocks, `Proc` objects, and lambdas. They retain a memory of their surrounding scope and can use and even update variables in that scope when they are executed, even if the block, `Proc`, or lambda is called from somewhere else**.

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

p results
```

Though the block passed to `for_each_in` is invoked from inside `for_each_in`, the block still has access to the `results` array through closure.

Where closures really shine, though, is when a method or block returns a closure. We can't return blocks, but we can return `Proc`s. We'll demonstrate this with `Proc`s; lambdas are very similar, but differ primarily in syntax.



```ruby
def sequence
  counter = 0
  Proc.new { counter += 1 }
end

s1 = sequence
p s1.call
p s1.call
p s1.call
puts

s2 = sequence
p s2.call
p s1.call  # note: this is s1
p s2.call
```

Here, the `#sequence` method returns a `Proc` that forms a closure with the local variable `counter`. Subsequently, we can call the returned proc repeatedly. Each time we do, it increments its own private copy of the `counter` variable.

Interestingly, we can create multiple `Proc`s from `sequence`, and each will have its own independent copy of `counter`. Thus, when we call `sequence` a second time and assign the return value to `s2`, the `counter` associated with `s2` is separate and independent of the `counter` in `s1`.



<u>Summary of lesson 1.4</u>

* blocks are one way that Ruby implements closures. Closures are a way to pass around an unnamed "chunk of code" to be executed later.
* blocks can take arguments, just like normal methods. but unlike normal methods, a block won't complain about the wrong number of arguments being passed to it.
* blocks return a value, just like normal methods.
* blocks are a way to defer some implementation decisions to method invocation time. It allows method users to refine a method at invocation time for a specific use case. It allows method implementers to build generic methods that can be used in a variety of ways.
* blocks are a good use case for "sandwich code" scenarios, like closing a `File` automatically.
* methods and blocks can return a chunk of code by returning a `Proc` or lambda.



<u>Lessson 1.10</u>

Good stuff about encapsulation, the public interface to a class, and class invariants. The public interface helps keep client code working by providing access to functionality in terms of its purpose rather than the implementation of the class or the representation of its objects. That way, we can keep the functionality and interface consistent even if we drastically change how methods are implemented and data is represented.



<u>Lesson1.14: Blocks and variable scope</u>

Only *local variables* follow the rule that outer scope-initialized variables are accessible in inner blocks but not vice versa. Methods do not, and method invocations can appear to be local variable names because of the non-required parentheses, so be careful.

* Closure and binding

A block is how Ruby implements the idea of a *closure*, which is a general computing concept of a "chunk of code" that you can pass around and execute at some later time. In order for this "chunk of code" to be executed later, it must understand the surrounding context from where it was defined. In Ruby, this "chunk of code" or closure is represented by a a `Proc` object, a lambda, or a block.

A `Proc` keeps track of its surrounding context, and drags it around wherever the chunk of code is passed to. In Ruby, we call this its **binding**, or surrounding environment/context. A closure must keep track of its binding to have all the information it needs to be executed later. This not only includes local variables, but also method references, constants and other artifacts in your code -- whatever it needs to execute correctly, it will drag all of it around.

Note that any local variables that need to be accessed by a closure must be defined *before* the closure is created.

Bindings and closures are at the core of variable scoping rules in Ruby. It's why "inner scopes can access outer scopes".

The stuff about bindings only capturing the local variables that the block uses, and the test with `pry`, at the end of the assignment appears to be out-of-date info.

Note from Pete Hanson: "Hmm... I can confirm that Ruby now seems to include all lexically scoped variables in a closure. I wonder if something has changed in `pry` or `binding` to allow access to variables that aren't used inside the block. It used to be that that did not work. The formal definition of a closure still limits the closure to free variables (that is, variables that are accessed but not created in a function or block). I'll make a note to get that assignment updated... Lexical scoping simply means that what's in scope can be determined by just looking at the structure of the surrounding code. Ruby isn't big on lexical scope, but with respect to the closures formed by blocks, procs, and lambdas, the lexical scope includes any variable that are defined in the surrounding code. (The variables have to be defined before the block/proc/lambda is defined.)"



<u>Lesson1.15: Symbol to proc</u>

When calling certain Ruby core class methods like `map`, we can substitute an explicit Symbol argument prefixed with `&` for an implicit block argument if we simply want to call the method of the name given by the Symbol on every element of the calling collection.

```ruby
[1, 2, 3, 4, 5].map { |n| n.to_s }
# has the same effect as
[1, 2, 3, 4, 5].map(&:to_s)
```

Note that the `&` must be followed by a Symbol that names a method that can be called on each element in the collection. This method does not work for methods that require arguments.

This shortcut works on every method that takes a block, not only on `map`.

`Symbol#to_proc`

Although the `&:method_name` syntax is related to the use of `&param_name` explicit block parameters in method parameter lists, this is something else because we're not working with explicit blocks here. (Explicit blocks can be identified by looking out for a `&` in the parameter list for a method.)

Instead, we're applying the `&` operator to an object (possibly referenced by a variable), and when applied to an object, Ruby attempts to convert the object to a block. When the object is a `Proc`, this is easy, converting a `Proc` to a block is natural for Ruby. However, if the object is not already a `Proc`, Ruby first attempts to convert it to a `Proc` by implicitly calling `to_proc` on the object, which should return a `Proc` object. Ruby then converts the resulting `Proc` to a block.

* `&:to_s` tells Ruby to convert the Symbol `:to_s` to a block
* Since `:to_s` is not a `Proc`, Ruby first calls `Symbol#to_proc` to convert the symbol to a `Proc`
* Now it is a `Proc`, Ruby then converts this `Proc` to a block

So my mental model for `&` is:

1. Used before the name of a parameter in the parameter list of a method definition, `&` signifies conversion of the implicit block argument to the method into a simple `Proc` object, which is assigned to that parameter
2. Used before an existing object, `&` signifies that Ruby should convert that object to a block. If the object is not a `Proc` (or lambda?), Ruby will implicitly call `to_proc` on the object, then convert the resulting `Proc` to a block.



<u>Summary of lesson 1</u>

We saw:

* blocks are just one way Ruby implements closures. `Proc`s and lambdas are others.
* closures drag their surrounding context/environment around, and this is at the core of how variable scope works
* blocks are great for pushing some decisions to method invocation time.
* blocks are great for wrapping logic, where you need to perform some before/after actions.
* we can write our own methods that take a block with the `yield` keyword
* when we `yield`, we can also pass arguments to the block
* when we `yield`, we have to be aware of the block's return value
* once we understand blocks, we can re-implement many of the common methods in the Ruby core library in our own classes
* the `Symbol#to_proc` method is a nice shortcut when working with collections
* how to return a chunk of code from a method or block



<u>Question: Lesson 1: Blocks, Implement improved default behavior for reduce, asked by Ryan Schaul</u>

A way to use only default parameters by using a parameter that gets `nil`-initialized if an argument is passed for the default parameter, `true` if no argument is passed

```ruby
def reduce(array, starting_total = omitted = true)
  total = (omitted ? array[0] : starting_total)
  counter = (omitted ? 1 : 0)

  while counter < array.size
    total = yield(total, array[counter])
    counter += 1
  end

  total
end
```

Similar to the more compressed version on StackOverflow:

```ruby
def reduce(array, default = (arg2_not_passed = true; array[0]))
  counter = (arg2_not_passed ? 1 : 0)
  memo = default

  while counter < array.size
    memo = yield(memo, array[counter])
    counter += 1
  end

  memo
end
```

I solved it by using a `*` operator to gather all arguments into an array and then checking the size of the array.



<u>Blocks and Method Calls, Lesson 1 Question by Josh Keller</u>

Contains an explanation of how closures 'capture' method calls. Basically the chunk of code contains the *name* or identifier, and the closure captures the reference of `self` in the scope where the closure was defined. When the chunk of code is executed, if the identifier is present in the chunk of code without parentheses then Ruby searches for a local variable, does not find it among the captured or block local variables, and then tries calling it on `self`, where `self` references whatever `self` was when the closure was created. Obviously, if there are parentheses after the identifier it just calls it straightaway on the closure-captured `self`.

Includes a vague description of `main`.



<u>Lesson 1: Question about closure and binding by Xulln</u>

Kind of a bad confusing thread. It ends with some very confused examples where no one seems to realize that we are calling `self.local_variables` and `self.binding` in the proc, and `self` references the `main` object/Object class. That's why we get a list of all the local variables defined in the Object class and not those specifically in the binding of the proc. The example calls `binding` on the proc, which calls `Proc#binding` rather than `Kernel#binding`, and that is why that call returns the list of only those variables included in the binding of the proc.

The main point is that when we call `Symbol#to_proc`, the proc that is created is essentially just a pass-through or wrapper around a dynamic call to the named method. So

```ruby
:my_method.to_proc
```

generates a proc that is basically like this:

```ruby
Proc.new { |caller| caller.my_method }
```

Then it gets turned into a block by `&`.

We can demonstrate like:

```ruby
pro = :my_method.to_proc

pro.call(3) # NoMethodError: Integer class doesn't know a `my_method` method

class Foo
  def my_method
    puts "Hi there, from Foo"
  end
end

foo = Foo.new

pro.call(foo) # "Hi there, from Foo"
[Foo.new, Foo.new, Foo.new].each(&:my_method)
# "Hi there, from Foo"
# "Hi there, from Foo"
# "Hi there, from Foo"
```

<u>Lesson 1: Question about what &block does exactly by Jason Overby</u>



## Lesson 2

Introduction - "If you must give a name to what [this lesson covers] you can think of it as *unit testing*. All advanced testing tools and methodologies build upon this knowledge"



<u>2.3:Minitest</u>

Minitest can do everything RSpec can but uses a more straightforward syntax. RSpec is a DSL, Minitest can also use a DSL, but its standard syntax is just Ruby.

Vocabulary:

* **Test Suite** -- this is the entire set of tests that accompanies your program or application. You can think of this as *all the tests* for a project.
* **Test** -- this describes a situation or context in which tests are run. For example, this test is about making sure you get an error message after trying to log in with the wrong password. A test can contain multiple assertions
* **Assertion** -- this is the actual verification step to confirm that the data returned by your program or application is indeed what is expected. You make one or more assertions within a test.

`require_relative` -- looks for file to `require` relative to directory of current file rather than in Ruby's installation directories

Our test classes subclass from `Minitest::Test` to gain the necessary methods for writing Minitest tests.

Within a test class we can write tests by creating an instance method whose name starts with `test_`. This naming convention lets Minitest know that the method is an individual test that needs to be run. Within the `test_` methods, we make *assertions*.

`assert_equal` takes two parameters: the first is the expected value, the second is the test or actual value produced by the piece of code we are testing.

`minitest-reporters` gem adds color

`require 'minitest/reporters'`

`Minitest::Reporters.use!` -- add these two lines to the top of the tests file

Sometimes you'll want to skip certain tests. Perhaps you are in the middle of writing a test, and do not want it run  yet, or for any other reason. We can use the `skip` keyword.

Thus far we've been using the assertion or assert-style syntax. Minitest also has a completely different syntax called expectation or spec-style syntax.

In expectation style, tests are grouped into `describe` blocks, and individual tests are written with the `it` method. We no longer use assertions, and instead use **expectation matches**. 



* Minitest is an intuitive test library. It comes installed with Ruby.
* Using Minitest is very easy, and you shouldn't be afrais to play around with it.
* Create a test file
* Create a test class by subclassing `Minitest::Test`
* Create a test by creating an instance method that starts with `test_`
* Create assertions with `assert_equal`, and pass it the expected value and the actual value
* Colorize Minitest output with `minitest-reporters`
* You can skip tests with `skip`
* Minitest comes in two syntax falvors: assertion style and expectation style. The latter is to appease RSpec users, but the former is far more intuitive for beginning Ruby developers.



<u>1.4: Assertions</u>

a full list of assertions can be found in the documentation for `Minitest::Assertions`

Besides equality, sometimes we want to assert that

* a specific error is raised
* something is printed to standard out
* an object must be of a certain class
* something must be `nil`
* something must not be `nil`



Assertions include:

* `assert(test)` - fails unless `test` is truthy
* `assert_equal(exp, act)` - fails unless `exp == act`
* `assert_nil(obj)` - fails unless `obj.nil?`
* `assert_raises(*exp) { ... }` - fails unless block raises one of `*exp`
* `assert_instance_of(cls, obj)` - fails unless `obj` is an instance of `cls`
* `assert_includes(collection, obj)` - fails unless collection includes `obj`



Interestingly, `assert_includes` calls the `assert` method twice behind the scenes. So each `assert_includes` leads to 2 assertions, not 1. This also applies to `refute_includes` as well as `assert_empty`, `assert_match`, and their `refute` counterparts. This oddity can be safely ignored.



<u>Refutations</u>

Refutations are the opposite of assertions. that is, they *refute* rather than *assert*. Every assertion has a corresponding refutation. For example, `assert`'s opposite is `refute`. `refute` passes if the object passed to it is falsy. Refutations all take the same arguments as their assertion opposite method.



<u>Assert Yourself: A Detailed Minitest Tutorial</u>

One of the biggest keys to producing quality software is properly testing your program under a wide variety of conditions. Doing this manually is tedious and error-prone, and frequently doesn't get done at all. This leads to buggy software,  and sometimes software that doesn't work at all.

Fortunately, modern programming environments support automated tests. Such tests can be run easily and often. It's possible to run them automatically before every commit or release.
