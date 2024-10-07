

Closure

Definition

* A closure is a general programming concept that allows programmers to save a "chunk of code" to be passed around and executed later. A closure binds to the surrounding artifacts at the point in our program where the closure is defined (such as local variables, "closing over" or "enclosing" the surrounding context that the code chunk needs in order to be executed later.
* We can think of closures as like anonymous methods or functions, but with an environment attached, which in Ruby is called the closure's "binding".
* Different languages implement closures differently, with varying levels of support. Some languages do not implement them at all.

Implementation

* In Ruby, there are three ways to work with closures: blocks, regular `Proc` objects, and lambdas. Procs and lambdas can be passed around as objects, first-class citizens. Blocks can only be passed to the method on which the block is defined, though a block can be invoked multiple times by that method or even converted to a `Proc` via prefixing a parameter name with the unary `&` operator.

Benefits

* In Ruby, we use closures, specifically blocks, to defer part of the implementation of methods to the point of invocation, allowing the method user to refine a generic method for the task at hand without affecting other users of the method. Many of Ruby's `Enumerable` methods, such as `map` and `sort`, are examples of this use of closures.
* Closures, particularly blocks, are used in Ruby to implement sandwich code methods, methods that perform some actions before and after the logic in the closure. `File::open` is an example of this use of closures.
* A method can return a closure; we can customize the closure that the method returns based on the method arguments.



Notes

Lesson 1:2

Definition

"A **closure** is a <u>general programming concept</u> that allows programmers <u>to save a "chunk of code"</u> and <u>execute it at a later time</u>. It's called a "closure" because it's said to bind its surrounding artifacts (i.e., names like variables and methods) and build an "enclosure" around everything so that they can be referenced when the closure is later executed.

"It's sometimes useful to to think of a closure as a method that you can pass around and execute, but it's not defined with an explicit name."

So, anonymous functions.

"Different programming languages implement closures in different ways. Some languages will have first-class support for it, while other languages won't deal with it at all."

Different programming languages implement closures differently and with varying degrees of support. Some languages have first-class support for closures; some languages do not implement closures at all.

1. General programming concept. A chunk of code that can be passed around and executed later. Called a closure because it binds its surrounding artifacts (such as local variables) and 'closes over' or builds an 'enclosure' for these artifacts so they can be accessed when the closure is executed later.
2. A closure is an anonymous function.
3. Different languages implement closures differently, some not at all. Languages that implement closures do so with varying degrees of support.



1. A closure is a general programming language concept that allows programmers to save a "chunk of code" into memory to be passed around and executed at a later time. In addition to the chunk of code, a closure also saves its context, binding its surrounding artifacts (such as local variables) and building an 'enclosure' around this environment so that its artifacts are available when the code is executed later. 
2. In a Ruby context, we can think of a closure as a method that can be passed around as an object, but a method defined without an explicit name. In addition to being an anonymous function, a closure also carries with it the environment it needs to execute, or its binding.
3. Different programming languages implement closures differently and with varying degrees of support. Some languages have first-class support for closures; some languages do not implement closures at all.



Implementation

"In Ruby, a closure is implemented through a `Proc` object, a lambda, or a block. That is, we can pass around these items as a "chunk of code" and execute them later."

"There are three main ways to work with closures in Ruby: instantiating an object from the `Proc` class, using lambdas, and using blocks"

1. In Ruby, a closure is implemented by a block, a Proc, or a lambda. We can pass these things around as a chunk of code and execute them later.

Benefits

"In this lesson, we'll focus mostly on blocks when we talk about closures. However, some features of closures are best illustrated by `Proc` objects, so we'll use them too - however, we won't go into any detail of why `Proc` objects are useful. For the most part, we will ignore lambdas; however, you should try to remember that lambdas are one way to work with closures in Ruby."

So most of the questions are likely to be on blocks. We need to understand Procs (particularly `Symbol#to_proc` and `&`) but we do not need to understand benefits of Procs. Lambdas I think we mainly just need to know their arity and that they are the third kind of closure in Ruby.

The Benefits of blocks would presumably include (1) deferring part of the implementation of a generic method to the moment of invocation and (2) sandwich code.

Lesson 2:3

Benefits (blocks)

* In Ruby, we use closures, specifically blocks, to defer part of the implementation of methods to the point of invocation, allowing the method user to refine a generic method for the task at hand without affecting other users of the method. Ruby's iterator methods, such as `map`, `select`, and so on, are examples of this use of closures.
* Closures, particularly blocks, are used in Ruby to implement sandwich code methods, methods that perform some actions before and after the logic in the closure. `File::open` is an example of this use of closures.
* A method can return a closure, meaning we can customize the closure that the method returns based on the method arguments.



"When to use blocks in your own methods"

"There are many ways that blocks can be useful but the two main use cases are:

1. Defer some implementation to method invocation decision... providing a way for method users to *refine* the method implementation, without actually modifying the method implementation for everyone else... Many of the core library's most useful methods are useful precisely because they are built in a **generic** sense, allowing us... to refine the method through a block at invocation time. If you encounter a scenario where you're calling a method from multiple places, with a little tweak in each case, it may be a good idea to try implementing the method in a generic way by yielding to a block.
2. Methods that need to perform some "before" and "after" actions - sandwich code... Sandwich code is a good example of the previous point about deferring implementation to method invocation. There will be times when you want to write a generic method that performs some "before" and "after" action. Before and after what? That's exactly the point -- the method implementor doesn't care; before and after *anything*. [Example given: timing a piece of code (whatever the block calls). "The responsibility for our method starts and stops at timing the action, without regard to what the actual action is. This is a good use case for blocks". More examples: timing, logging, notification systems] ... Another area where before/after actions are important is in resource management, or interfacing with the operating system. Many OS interfaces require you, the developer , to first allocate a portion of a resource, then perform some clean-up to free up that resource. Forgetting to do the clean-up can result in dramatic bugs -- system crashes, memory leaks, file system corruption. [Gives example of `File::open`]"

goes on to talk about converting given block to proc with `&` parameter

"Using Closures"

"We won't do much with this here in the Ruby courses, but a very powerful capability in Ruby and many other languages is the ability to pass chunks of code -- closures -- around in a program. As described earlier, closures are formed by blocks, `Proc` objects, and lambdas. They retain a memory of their surrounding scope and can use and even update variables in that scope when they are executed, even if the block, `Proc`, or lambda is called form somewhere else."

"Where closures really shine, though, is when a method or block returns a closure. We can't return blocks, but we can return `Proc`s. We'll demonstrate this with `Proc`s; lambdas are very similar, but differ primarily in syntax."







Code samples

**1:3: Writing methods that take Blocks: Using Closures**

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



**1:14: Closures and Scope**

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

