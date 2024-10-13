I feel 'blocks and variable scope' is pretty much covered by this topic, at least in terms of material



Material:

1:2: Closures in Ruby

1:4: Writing Methods that take Blocks (just for benefits of closures)

1:14: Blocks and Variable Scope (for scope and binding)

1: Question: Blocks and Method Calls



Closure

Definition

* A closure is a general programming concept that allows programmers to save a "chunk of code" to be passed around and executed later. 
* A closure binds to the surrounding artifacts at the point in our program where the closure is defined (such as local variables), "closing over" or "enclosing" the surrounding context that the code chunk needs in order to be executed later.
* We can think of closures as like anonymous methods or functions, but with an environment attached, which in Ruby is called the closure's "binding".
* Different languages implement closures differently, with varying levels of support. Some languages do not implement them at all.

Implementation

* In Ruby, there are three ways to work with closures: blocks, regular `Proc` objects, and lambdas. Procs and lambdas can be passed around as objects, first-class citizens. Blocks can only be passed to the method on which the block is defined, though a block can be invoked multiple times by that method or even converted to a `Proc` via prefixing a parameter name with the unary `&` operator.

Benefits

* In Ruby, we use closures, specifically blocks, to defer part of the implementation of methods to the point of invocation, allowing the method user to refine a generic method for the task at hand without affecting other users of the method. Many of Ruby's `Enumerable` methods, such as `map` and `sort`, are examples of this use of closures.
* Closures, particularly blocks, are used in Ruby to implement sandwich code methods, methods that perform some actions before and after the logic in the closure. `File::open` is an example of this use of closures.
* Closures allow us to write more generic methods
* A method can return a closure; we can customize the closure that the method returns based on the method arguments.



Binding

1. Closures retain a memory of the local variables in outer scopes at the point of the source code where the closure is created.
2. A local variable must be initialized before the closure is created for the closure to bind it.
3. If a local variable that is bound by a Proc or lambda is reassigned after the Proc or lambda is created, that reassignment will be reflected in the binding of the Proc or lambda. The closure binds to the variable itself, not the value of the variable.
4. A closure must keep track of its binding to have all the information it needs to be executed later (in a possibly different scope). This not only includes local variables, but also method references, constants and other artifacts in your code -- whatever it needs to execute correctly.



Scoping rules:

Local variables:

* A closure can access local variables from "outer" scopes at the point in the source code where the closure is created.
* A closure can only access local variables that are initialized before the closure is created.
* A local variable instantiated within a closure is local to that closure. If another closure is created within the closure, it will bind the closure-local variable. This is what is meant be "outer and inner block scopes"
* Once the closure is created, reassigning a local variable outside of the closure will be reflected in the closure's binding. The captured local variable is effectively an alias for the local variable outside the closure.
* A closure will keep a local variable alive even after the method that initialized it has returned.
* Multiple calls to a method that returns a closure that accesses a local variable from the method's scope will generate multiple closures that each have their own unique local variable of the same name. The method call's local variable will be a new variable each time the method is called.

Instance variable:

* A closure can only refer to an instance variable if it is initialized before the closure is *executed*. If the closure is executed before the instance variable is initialized, the reference will simply return `nil`, as references to uninitialized instance variables always do.
* The instance variable still pertains to the object instance that encapsulates it. The value of `self` is bound by the closure.
* A closure can instantiate an instance variable in the object referenced by `self` when the closure is created.

Class variables:

The same rules apply to class variables as instance variables (except that referencing an uninitialized class variable raises a `NameError` instead of evaluating to `nil`).

Constants

* Constant lookups from a closure follow the same lexical scoping rules as elsewhere, though the lookups will begin from the lexical scope of the closure's definition, not where the closure is called.
* Constants need to be defined in the lexical scope of the closure's definition before the closure is *executed* but not before the closure is created.
* A closure cannot initialize a constant (raises `SyntaxError`, dynamic constant assignment, same as methods).

Methods:

* A closure can reference methods defined after the closure is created so long as the method is defined before the closure is executed.

With blocks, we can generally assume that a block can only access artifacts that exist before the block is created, since the block will generally be executed almost immediately by the method invocation on which the block is defined (assuming the block is not converted to a Proc and returned or passed to other methods). With Procs and lambdas we must be careful to notice when the Proc or lambda is actually called in order to predict which artifacts (other than local variables) it can access. Local variables always need to be initialized before a closure of any kind is created or the closure cannot access them.



Notes

method scope from Question Blocks and Method Calls (lesson 1)

"Ruby handles method look ups differently than variables"

"We're used to calling methods explicitly on objects... When we don't use an explicit caller, the method is implicitly called on `self`... If we try to invoke a method without an explicit caller and *without parentheses*, Ruby will first check to see if there is a local variable of that name within scope (which in the case of a block includes its binding). If there is then Ruby will return the object referenced by the local variable, if not it will attempt to call a method of that name on `self`."

So using an identifier that doesn't exist will raise a `NameError`, using an identifier followed by parentheses that doesn't exist will raise a `NoMethodError`.

"So what is the `main` object? It's an instance of the `Object` class... but... it's also the `Object` class itself (kind of, it's more complex than that, but... that's a good enough mental model)... methods defined in the `main` scope are `private` by default."

"This means that we can define methods in the `main` scope, and then call those methods on `self`"

What he's trying to say is that:

Methods defined in the `main` scope are actually defined as private instance methods of the Object class. We can call private methods without an explicit caller and the implicit caller will be the current object `self`. This means that we can always call `main` toplevel methods implicitly on`self`, because, apart from BasicObject instances, all objects in Ruby inherit from Object.

When we invoke a method that does not exist yet within a Proc or lambda definition, it will not raise an exception so long as the method gets defined before the Proc or lambda is actually executed. Ruby will check the method lookup path dynamically when the Proc is called, and so long as the method is in the method lookup path for the class of the object `self` (in the closure's context) at the time the Proc is executed, the method will be successfully called. 



```ruby
my_proc = Proc.new { puts d }

def d
  4
end

my_proc.call # => 4
```

On line 1, we create the Proc object `my_proc`, whose code references `d`. An instance variable `d` that is initialized after this would not be available to `my_proc`, but we can define a method `d`, as we do on lines 3-5.

When we call `my_proc` on line 7, the code defined on line 1 executes. Ruby checks for a local variable `d` in the Proc's scope, including its binding, and does not find one. Next, Ruby treats `d` as a method call without parentheses invoked implicitly on `self`. Ruby searches the method lookup path of the class of the object referenced by `self` in the closure's binding. This object is `main` and its class is Object. Since our `d` method is defined in the `main` scope (and is therefore defined as a `private` instance method of Object), Ruby finds the method in the method lookup path and successfully calls it. `d` returns `4`, which is passed to the `puts` method to be output to screen. This is the last expression in the Proc, so the `my_proc` returns `nil` (the return value of `puts`) and execution returns to line 7, where the program ends.

If we were to call  `my_proc` before `d` was defined as a method, it would raise a `NameError`:

```ruby
my_proc_4 = Proc.new { puts d }

p my_proc_4.call # => NameError: undefined local variable or method `d' for main:Object

def d
  4
end
```

"This dives a little deeper under the hood than we cover in the course."



Binding

Lesson 1:14

The thing that is bothering me about closure and binding is that the Binding object of the Proc object appears to have access to variables that the Proc does not have access to.

```ruby
pr = proc { p foo }
foo = 5
p pr.binding.local_variables # [:pr, :foo] -- the binding knows about variable `foo`
pr.binding.eval("p foo") # 5
pr.call # raises NameError -- the proc does not know about `foo`
```

However, this behavior doesn't seem different from the behavior of Binding objects generally:

```ruby
b = binding
foo = 5
p b.local_variables # [:b, :foo]
```

What's even weirder is that this is different in IRB, where any variables initialized after the Binding object is created are not present in the `local_variables` list. (Though a `:_` pseudovariable is present there instead).

So my conclusion is that although closure binding involves the instantiation of a Binding object (available through `Proc#binding`), the closure's binding (as a scope/envirnoment) is not coextensive with its encapsulated Binding object. The Binding object clearly can have access to local variables that the closure does not have access to.

Furthermore, we should probably not rely on a Binding object having access to variables initialized after the Binding is instantiated even if it this seems to be the case, at least outside of IRB.



"The `Proc` is aware of the new value [for a local variable captured/bound by the closure] even though the variable was reassigned after the `Proc` was defined. This implies that the `Proc` keeps track of its surrounding context, and drags it around wherever the chunk of code is passed to. In Ruby, we call this its **binding**, or surrounding environment/context."

"A closure must keep track of its binding to have all the information it needs to be executed later. This not only includes local variables, but also method references, constants, and other artifacts in your code -- whatever it needs to execute correctly, it will drag all of it around... Note that any local variables that need to be accessed by a closure must be defined *before* the closure is created, unless the local variable is explicitly passed to the closure when it is called [as an argument]..."

1. Closures retain a memory of the local variables initialized before they are created in lexical scope at that point of the source code.
2. If a local variable that is bound by a Proc or lambda is reassigned after the Proc or lambda is created, that reassignment will be reflected in the binding of the Proc or lambda. The closure binds to the variable itself, not the value of the variable.
3. A closure must keep track of its binding to have all the information it needs to be executed later (in a possibly different scope). This not only includes local variables, but also method references, constants and other artifacts in your code -- whatever it needs to execute correctly.







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

This example demonstrates defining a method after a Proc is created, question what would happen if this code were run:

```ruby
my_proc = Proc.new { puts d }

def d
  4
end

my_proc.call
```

