# Closures #

## **Closure**

**Definition**

A closure is a general programming concept that allows programmers to save a "chunk of code" (which we can think of as an anonymous function or method) to be passed around and executed later. A closure binds the chunk of code to the surrounding artifacts (such as local variables) at the point in our program where the closure is defined, "closing over" the surrounding context that the code chunk needs in order to be executed later. We can think of closures as like anonymous methods, or anonymous functions, but with an environment attached, which in Ruby is called the closure's "binding".

When a variable is bound by a closure, it is the variable itself that the closure can access, not simply the object that the variable references. Therefore we can reassign variables in a closure’s code and the reassignment will be reflected in the scope where the variable was initialized.

Different languages implement closures differently, with varying levels of support. Some languages do not implement them at all.

- A closure is a general programming concept that allows programmers to save a "chunk of code" to be passed around and executed later.
- A closure binds to the surrounding artifacts at the point in our program where the closure is defined (such as local variables), "closing over" or "enclosing" the surrounding context that the code chunk needs in order to be executed later.
- We can think of closures as like anonymous methods or functions, but with an environment attached, which in Ruby is called the closure's "binding".
- Different languages implement closures differently, with varying levels of support. Some languages do not implement closures at all.

**Implementation**

In Ruby, there are three ways to work with closures: blocks, regular `Proc` objects, and lambdas. Procs and lambdas can be passed around as objects; they are first-class citizens. Blocks can only be passed to the method invocation on which the block is defined. However, a block can be invoked multiple times by that method, or even converted to a `Proc` object by prefixing the final parameter in the parameter list of the method definition with the unary `&` operator.

- In Ruby, there are three ways to work with closures: blocks, regular `Proc` objects, and lambdas. Procs and lambdas can be passed around as objects, first-class citizens. Blocks can only be passed to the method on which the block is defined, though a block can be invoked multiple times by that method or even converted to a `Proc` object by prefixing the final parameter in the parameter list with the unary `&` operator.

**Benefits**

In Ruby, we use closures, particularly blocks, to defer part of the implementation of methods to the point of invocation, allowing the method user to refine a generic method for the task at hand without affecting other users of the method. Many of Ruby's `Enumerable` methods, such as `map` and `sort`, are examples of this use of closures.

Closures, particularly blocks, are used in Ruby to implement sandwich code methods, methods that perform some actions before and after the logic in the closure. `File::open` is an example of this use of closures.

Closures allow us to write more generic methods. A method can return a closure; the method can customize the closure that the method returns based on the method arguments.

- In Ruby, we use closures, specifically blocks, to defer part of the implementation of methods to the point of invocation, allowing the method user to refine a generic method for the task at hand without affecting other users of the method. Many of Ruby's `Enumerable` methods, such as `map` and `sort`, are examples of this use of closures.
- Closures, particularly blocks, are used in Ruby to implement sandwich code methods, methods that perform some actions before and after the logic in the closure. `File::open` is an example of this use of closures.
- Closures allow us to write more generic methods
- A method can return a closure; the method can customize the closure that the method returns based on the method arguments.

## **Binding**

A closure retains access to the variables, constants, methods, and other artifacts it needs in order to be executed later that are in scope at the time and location in the program where the closure was created. We say that the closure creates a *binding*, or that the closure *binds* its code with the in-scope artifacts.

Closures bind the local variables in scope at the time and location in the program where the closure is created. A local variable must be initialized before the closure is created for the closure to bind it. If a local variable that is bound by a Proc or lambda is reassigned another object after the Proc or lambda is created, that reassignment will be reflected by the Proc or lambda. The closure binds the variable itself, not the value of the variable.

A closure must keep track of its binding to have all the information it needs to be executed later (in a possibly different scope). This not only includes local variables, but also method references, constants, and other artifacts in the environment -- everything in the surrounding context that it needs to execute correctly.

- Closures retain a memory of the local variables in scope at the time and location in the source code where the closure is created. A closure ‘binds’ a chunk of code with the artifacts in scope.
- A local variable must be initialized before the closure is created for the closure to bind it.
- If a local variable that is bound by a Proc or lambda is reassigned after the Proc or lambda is created, that reassignment will be reflected in the binding of the Proc or lambda. The closure binds to the variable itself, not the value of the variable.
- A closure must keep track of its binding to have all the information it needs to be executed later (in a possibly different scope). This not only includes local variables, but also method references, constants and other artifacts in your code -- whatever it needs to execute correctly.

## **Scoping rules**

**Local variables:**

A closure retains access to local variables that are in scope at the time and place in the program where the closure is created. This is why blocks can access local variables from the "outer" scope. A closure can only access local variables that are initialized before the point in the source code where the closure is created. A local variable instantiated within a closure is local to that closure; that is why “inner” scope block variables are not accessible in the “outer” scope. If another closure is created within the closure, it will bind the closure-local variable. This is what is meant be "outer and inner block scopes".

Once a closure is created, reassigning a local variable outside of the closure will be reflected in the closure's binding. This is easiest to discern with procs and lambdas, since they are not necessarily immediately passed to a method invocation and can be executed at any later time. The captured local variable is effectively an alias for the local variable outside the closure.

A closure will keep a local variable alive even after the method that initialized it has returned. Multiple calls to a method that returns a closure that accesses a local variable from the method's scope will generate multiple closures that each have their own unique local variable of the same name. The method call's method-local variable will be a new variable each time the method is called.

- A closure can access local variables from "outer" scopes at the point in the source code where the closure is created.
- A closure can only access local variables that are initialized before the closure is created.
- A local variable instantiated within a closure is local to that closure. If another closure is created within the closure, it will bind the closure-local variable. This is what is meant be "outer and inner block scopes"
- Once the closure is created, reassigning a local variable outside of the closure will be reflected in the closure's binding. The captured local variable is effectively an alias for the local variable outside the closure.
- A closure will keep a local variable alive even after the method that initialized it has returned.
- Multiple calls to a method that returns a closure that accesses a local variable from the method's scope will generate multiple closures that each have their own unique local variable of the same name. The method call's local variable will be a new variable each time the method is called.

**Instance variable:**

A closure can only refer to an instance variable if it is initialized before the closure is *executed*. If the closure is executed before the instance variable is initialized, the reference will simply return `nil`, as references to uninitialized instance variables always do.The instance variable still pertains to the object instance that encapsulates it. The value of `self` is bound by the closure.A closure can instantiate an instance variable in the object referenced by `self` when the closure is created.

- A closure can only refer to an instance variable if it is initialized before the closure is *executed*. If the closure is executed before the instance variable is initialized, the reference will simply return `nil`, as references to uninitialized instance variables always do.
- The instance variable still pertains to the object instance that encapsulates it. The value of `self` is bound by the closure.
- A closure can instantiate an instance variable in the object referenced by `self` when the closure is created.

**Class variables:**

The same rules apply to class variables as instance variables (except that referencing an uninitialized class variable raises a `NameError` instead of evaluating to `nil`).

**Constants**

Constant lookups from a closure follow the same lexical scoping rules as elsewhere, though the lookups will begin from the lexical scope of the closure's definition, not where the closure is called.

Constants need to be defined in the lexical scope of the closure's definition before the closure is *executed* but not before the closure is created.A closure cannot initialize a constant (raises `SyntaxError`, dynamic constant assignment, same as methods).

- Constant lookups from a closure follow the same lexical scoping rules as elsewhere, though the lookups will begin from the lexical scope of the closure's definition, not where the closure is called.
- Constants need to be defined in the lexical scope of the closure's definition before the closure is *executed* but not before the closure is created.
- A closure cannot initialize a constant (raises `SyntaxError`, dynamic constant assignment, same as methods).

**Methods:**

A closure can reference in-scope methods defined after the closure is created so long as the method is defined before the closure is executed.

- A closure can reference methods defined after the closure is created so long as the method is defined before the closure is executed.

## Detailed explanation of why top-level method references act differently to local variable references in closures

In Ruby, closures retain access to the variables, constants and methods that are in scope at the time and location in the program where the closure is created; the closure binds its code chunk with the in-scope artifacts. For local variables, this involves keeping track of which local variables have been initialized in the current scope *before* the point where the closure is created. If a local variable is initialized within the same scope for local variables but *after* the creation of the closure, the closure will not bind that local variable. For methods, the case is different.

In Ruby, unlike in some languages, a new method can be added to a class at any time in the program. Method invocation in Ruby is handled dynamically such that a method will be successfully called so long as its definition exists by the time it is invoked.

Methods that are defined at top-level are implicitly defined as private instance methods of the Object class, from which almost every class in Ruby inherits. This is why top-level methods are available to be called (almost) everywhere. When we call a top-level method without an explicit caller, we are implicitly calling it on `self`, which everywhere (except within a BasicObject instance) references an instance of some class that inherits from Object, since nearly every class inherits from Object (including Class). At top-level, `self` references `main`, a special instance of the Object class in whose context (most) top-level code executes.

One of the artifacts bound by a Ruby closure is the current value of `self`. All method calls without an explicit caller are called implicitly on the object currently referenced by `self`. Therefore, so long as a top-level method of a name used in a closure's code chunk is defined before that closure is actually executed, the method will be called successfully.

## `&:symbol` and `Symbol#to_proc`

In the context of passing an argument to a method invocation, prefixing the argument with the unary `&` operator will signify to Ruby that we are attempting to convert that object to a block to be passed implicitly to the method as we would an ordinary block definition.

For Proc objects this is straightforward. However, we can also prefix `&` to a Symbol argument, and the `&` operator will implicitly call the `Symbol#to_proc` method in order to receive a Proc object that can be converted to a block.

`Symbol#to_proc` assumes that the Symbol it is called on is the name of a method that does not require arguments. So if, for instance, `to_proc` is called on the symbol `:to_s`, it will return a Proc whose code would be equivalent to:

```ruby
 { |object| object.to_s }
```

The unary `&` operator then converts this Proc object to a block to be implicitly passed to the method call.

This technique is only useful for certain kinds of methods. The Proc produced by `Symbol#to_proc` will always take the form given above. Consequently, this technique is not useful for Symbols that name methods that require us to pass arguments. However, it is very useful shorthand when we wish to call the same method with no arguments in a block passed to an iterator method such as `Array#map`.

```ruby
["the", "great", "gatsby"].map(&:capitalize)
# => ["The", "Great", "Gatsby"]
```

It is also useful for chaining iterator method calls because of its brevity:

```ruby
[1, 2, 3, 4, 5].select(&:even?).map(&:to_s)
# => ["2", "4"]
```

We can also call `Symbol#to_proc` manually if we wish:

```ruby
method_proc = :capitalize.to_proc
["the", "great", "gatsby"].map(&method_proc)
# => ["The", "Great", "Gatsby"]
```

## Blocks vs Procs and lamdas with respect to scope

With blocks, we can generally assume that a block can only access artifacts that exist before the block is created, since the block can only be executed by the method invocation on which the block is defined (assuming the block is not converted to a Proc and returned or passed around). With Procs and lambdas we must be careful to notice when the Proc or lambda is actually executed in order to predict which artifacts (other than local variables) it can access. Local variables always need to be initialized before a closure of any kind is created or the closure cannot access them.

## Explicit block parameters

Every method, regardless of its definition, can take an block as an implicit argument, even if the method definition does not make use of it with the `yield` keyword. However, a method can instead take the block as an explicit argument, denoted in the method definition by an `&` prefixed to the last parameter in the parameter list.

The `&` operator prefixed to a method parameter will convert a given implicit block argument to a Proc object and assign the Proc to the parameter. Thereafter, the Proc can be passed around, returned, and generally treated like any other object. The explicit block parameter itself is just another parameter, which can be reassigned like any other local variable. The explicit block parameter variable is not referenced with a `&` inside the body of the method definition, only in the parameter list.

If no block is given when the method is invoked, the explicit block parameter will be assigned `nil`, so we may wish to test for this before invoking Proc methods on it.

The advantages of an explicit block over an implicit block are the advantages of a first-class citizen, an object, which can be passed around to other methods. This is more flexible than the more spectral presence of an implicit block, which can only be interacted with or executed only from within the method to which the block is implicitly passed .

## Arity in relation to blocks and methods

Blocks (and Procs) are said to have 'lenient arity' in relation to their arguments, and methods (and lambdas) have 'strict arity'.

Lenient arity means that a block does not care if too many or too few arguments are passed with respect to the block's parameters. Any excess arguments are ignored, and if a parameter does not receive a corresponding argument, the parameter is simply assigned `nil`. No exception will be raised regardless of how many arguments are passed (unlike with methods). For example,

```ruby
def pass_two_args
  yield(1, 2)
end

pass_two_args { |a, b, c| puts "a = #{a} and b = #{b} and c = #{c.inspect}" }
  # "a = 1 and b = 2 and c = nil"
pass_two_args { |a, b| puts "a = #{a} and b = #{b}" }  # "a = 1 and b = 2"
pass_two_args { |a| puts "a = #{a}" }  # "a = 1"
pass_two_args { puts "both arguments ignored" } # "both arguments ignored"
```

Methods have strict arity, which means we must pass exactly the right number of required parameters to a method or an `ArgumentError` will be raised. For example,

```ruby
 def get_two_args(a, b)
   puts "a = #{a} and b = #{b}"
 end
 
 get_two_args(1, 2)  # "a = 1 and b = 2"
 get_two_args(1, 2, 3)  # raises ArgumentError
 get_two_args(1)  # raises ArgumentError
 get_two_args()  # raises ArgumentError
```

The differing arity of blocks and methods means that methods enforce the count of required arguments and blocks do not.

## **How does local variable scope work with blocks in Ruby?**

Blocks are one of the ways Ruby implements closures, a general programming concept. A closure is a "chunk of code" that we can pass around and execute later. A closure retains access to the variables, methods, constants and other artifacts that are in scope at the time and location where the closure is created, "closing over" the in-scope items that the code needs to be executed later; we call this a closure's 'binding'.

With respect to local variables, a Ruby closure, such as a block, will bind the local variables that are in scope and initialized before the closure is created. The block binds the variable itself, not simply the value of the variable, which means that if we reassign a bound local variable, then that variable is reassigned outside of the block too, since they are the same variable. The local variables bound by the block from the scope in which the block is created can be seen as "outer scope" local variables.

We can also initialize block-local variables, whose scope is the block itself. These variables cannot be accessed from the "outer" scope. These block-local variables can be seen as "inner scope" local variables. If we define another block within the first block, the inner block binds the outer block's block-local variables, and the inner block has its own potential set of block-local local variables that cannot be accessed from the outer block; we thus create nested "inner" and "outer" scopes.

For example,

```ruby
 outmost_variable = nil
 
 1.times do
   p outermost_variable # outmost_variable can be accessed here

   inner_variable = nil  # cannot be accessed from top-level

   1.times do
     p outermost_variable
     p inner_variable  # outmost_variable and inner_variable can be accessed here

     innermost_variable = nil  # can only be accessed in this innermost block

   end

   # here, we cannot access innermost_variable

 end
 
 # here, we cannot access innermost_variable or inner_variable
```

## What are the two main use cases for methods that take a block?

When writing a method, there are many ways that it can be useful to have the method yield to a block, but there are two main use cases for doing so. The first is when we wish to defer some part of the method implementation to the method user at the time of invocation. This allows us to write flexible, generic methods with a great variety of possible use cases.

Many of Ruby’s core classes and modules are built in this generic way. For instance, `Array#map` represents a generic transformation; the precise nature of the transformation is left entirely to the user at invocation time. This makes the method a great deal more flexible and useful than a method that simply performs a predetermined action on every member of an Array. Even a method that allowed the user to pass in a flag to choose from several transformation options would still be vastly more limited than calling the `Array#map` method with a block.

Blocks allow the method implementer write generic methods that defer part of the implementation to invocation time; the method user can then refine the implementation to their specific use case without modifying the method for other users.

The second main use case is when we need a ‘sandwich code’ method, a method that performs some ‘before’ step, then some intervening actions, then an ‘after’ step. This pattern is useful in many areas of programming for a variety of situations, such as logging, benchmarking, notifications, and system resource management. In Ruby, the method implementer can let the method user specify the intervening actions — which could be anything — in a block when invoking the method.

For example, Ruby’s `File::open` method can be called with a block; the method opens a file, passes it to the block, and then, when the block returns, closes the file to ensure the file handle is freed. This way, the method implementer abstracts away the details of file handle management, and the method user can simply manipulate the file in the block without needing to remember to close the file manually. The user can invoke the method with a block that operates on the file safe in the knowledge that the file will be closed after the code in the block has executed.





# Testing

### Testing terminology

Test Suite: this is the entire set of tests that accompanies your program or application. You can think of this as *all the tests for a project*.Test: this describes a situation or context in which tests are run. For example, this test is about making sure you get an error message after trying to log in with the wrong password. A test can contain multiple assertions.Assertion: this is the actual verification step to confirm that the data returned by your program or application is indeed what is expected. You make one or more assertions within a test.

- Test Suite: this is the entire set of tests that accompanies your program or application. You can think of this as *all the tests for a project*.
- Test: this describes a situation or context in which tests are run. For example, this test is about making sure you get an error message after trying to log in with the wrong password. A test can contain multiple assertions.
- Assertion: this is the actual verification step to confirm that the data returned by your program or application is indeed what is expected. You make one or more assertions within a test.

or a variation, with slight contradictions to the first set:

A test step, or simply, a test, is the most basic level of testing. A test step simply verifies that a certain expectation has been satisfied... Test steps employ either an assertion or an expectation, depending on your testing framework. [In lesson 2:3, this maps to "assertion" rather than "test"]A test case is a set of actions that need to be tested combined with any appropriate test steps. This may include instantiation of an object, calling methods on it, and then making an assertion to verify the expected results. Typically, only one test step is used per test case; some developers insist on this, others are more flexible.A test suite is a collection of one or more test cases that, taken together, demonstrate whether a particular application facet is operating correctly. We use this term quite loosely: a test suite can test an entire class, a subset of a class, or a combination of classes, all the way up to the complete application.

- A test step, or simply, a test, is the most basic level of testing. A test step simply verifies that a certain expectation has been satisfied... Test steps employ either an assertion or an expectation, depending on your testing framework. [In lesson 2:3, this maps to "assertion" rather than "test"]
- A test case is a set of actions that need to be tested combined with any appropriate test steps. This may include instantiation of an object, calling methods on it, and then making an assertion to verify the expected results. Typically, only one test step is used per test case; some developers insist on this, others are more flexible.
- A test suite is a collection of one or more test cases that, taken together, demonstrate whether a particular application facet is operating correctly. We use this term quite loosely: a test suite can test an entire class, a subset of a class, or a combination of classes, all the way up to the complete application.

### Code Coverage

Code coverage refers to how much of a program's code is tested by a test suite: both the public and private code. To achieve 100% code coverage, we need to ensure that all public and private methods and all paths of branching logic are tested by our test suite. However, 100% code coverage does not mean that every possible edge case is considered by these tests; it does not even mean the program as a whole is operating correctly. Thus, code coverage is simply one metric that you can use to gauge code quality.

### Regression Tests

We use regression tests to check for bugs that occur in formerly working code after we make a change to the codebase. The use of regression tests means that we don't need to verify manually that everything is working after each change.

### Unit Tests

Unit tests check the specific functionality of a small piece, or unit, of code. For instance, this might be a class or a module. We test the unit in isolation to verify that it operates correctly.

### Minitest vs RSpec

Minitest is part of the Ruby standard library whereas RSpec is not. Minitest is a bundled gem, meaning it is installed with the Ruby installation as the default Ruby testing library, though it can be uninstalled if necessary. RSpec is a normal gem that must be deliberately installed.

In terms of basic functionality, Minitest can do anything RSpec can do. However, Minitest has a straightforward default syntax that is largely just Ruby code. RSpec is a Domain Specific Language designed to allow us to write tests that read more like English.

While Minitest can optionally use a DSL, the standard Minitest syntax is for the most part standard Ruby syntax. This can make writing and understanding Minitest tests simpler than in RSpec, especially for beginner developers.

Minitest's standard syntax is assert-style (or assertion-style) syntax. Minitest's optional DSL allows us to write spec-style (or expectation-style) syntax, which is similar to RSpec's syntax. Spec-style syntax might read more like English natural language, but it requires learning more new (and somewhat opaque) syntax to achieve this.

Minitest does not have all the flexibility and power of RSpec but it does have all the functionality necessary for most testing scenarios.

### SEAT Approach

The SEAT approach to testing breaks down the writing of a test into four main steps, each of which is denoted by a letter in the acronym SEAT.

- Set up the necessary objects
- Execute the code we wish to test against the objects
- Assert that the code we have executed performed as expected
- Tear down any lingering artifacts

S stands for Setup. This step involves setting up the necessary objects for a test case; these are commonly assigned to instance variables to be used in within the test cases. In Ruby's Minitest framework, we can extract any set up actions common to all of the test cases in a test class to a `#setup` method. The `#setup` method is automatically called before each test method in the class is run.

T stands for Teardown. This final step involves tearing down and cleaning up any lingering artifacts, such as open files, database handles, and so on. In Ruby's Minitest framework, we can extract teardown operations common to all test cases in a test class to a `#teardown` method. The `#teardown` method is called automatically after each test method has finished executing.

`#setup` and `#teardown` are both optional, and we can define one without the other.

E stands for Execute. This necessary step involves executing the code we wish to test against the objects being tested. All test cases will involve an execute step.

A stands for Assert. This step is the actual test step. We assert the code we just executed has behaved as expected. We assert, using one of Minitest's many assertions, that the actual result of the Execute step conforms to our expectations. All tests involve this step.

### Testing Equality

The `assert_equal` assertion is one of the most commonly used assertions. The kind of equality asserted by `assert_equal(expected, actual)` is value equality, or equivalence of states. The method it uses to compare the `expected` object with the `actual` object is the `==` method, which returns `true` if the caller and argument have an equivalent representative object value, `false` otherwise. `assert_equal` fails unless `expected == actual`. This means that an appropriate `==` method must be defined for the objects being asserted against.

The other form of equality we may wish to assert is object equality. For this we use the `assert_same` assertion. When we use `assert_same(expected, actual)`, we are testing whether the object referenced by `expected` is the same object with the same object id as the object referenced by `actual`; `assert_same` will fail unless this is the case. `assert_same` uses the `equal?` method to test for object equality, usually inherited from `BasicObject`. We can think of `assert_same` as asserting that `expected.object_id == actual.object_id`.

So `assert_equal` fails unless value equality is established between two (usually) different objects, and `assert_same` fails unless two variables reference the same object.

### Assertions

An assertion is an actual test step, the verification step that confirms the actual data returned or output by our code is the data we expect. We can make one or more assertions within a test case. If the data returned by our program matches the expected data, the assertion passes; otherwise, the assertion fails.

Refutations are the logical opposite of assertions. A refutation seeks to deny that the actual data returned by our code matches some proscribed data. A refutation fails if the data matches; otherwise, the refutation passes.

Assertions are vastly more common than refutations, though sometimes the logic of a refutation is more readily comprehensible. Most assertion methods have a corresponding refutation. The refutation form of an assertion takes the same positional arguments and blocks as the assertion, but with the logic of passing or failure inverted.



# Ruby Tools

## **Purposes**

### RubyGems

RubyGems, most commonly just called Gems, are packages of code that we can download, install, and use in Ruby programs or run from the command line. Gems are managed by the `gem` command, which comes installed with Ruby (version 1.9 onward).

Gems are downloaded by the `gem` command from a RubyGems remote library, usually [`rubygems.org`](http://rubygems.org), and installed in a local library, the precise location of which within the filesytem depends on the type of Ruby installation we are using.

Most Ruby projects use RubyGems as the distribution mechanism. A Ruby project must observe certain practices in order to be packaged and distributed as a Gem; a project must conform to a common directory structure and maintain a `.gemspec` file.

RubyGems is a packaging format and associated ecosystem that makes it easy to package, distribute, download, install and use Ruby code.

### Ruby Version Managers

Ruby version managers are programs that allow us to install, manage, and utilize multiple versions of Ruby

Ruby has features added, removed, or changed with each new release. Software projects generally standardize on a particular version of a language. Therefore, if we need to work on multiple Ruby projects, all standardized on different versions of Ruby, Ruby version managers allow us to manage and move between multiple different Rubies as we switch between different projects

The two most common Ruby version managers are `RVM` and `rbenv`. Their feature set is roughly the same (although `rbenv` requires plug-ins); one may be easier to work with than the other depending on the system we are developing on.

Ruby version managers also allow us to work with multiple versions of the utilities associated with each Ruby version, as well as the different RubyGems installed for each Ruby. Ruby version managers thus allow us to install and use multiple different Rubies, each with their own associated developing environment.

### Bundler

Bundler is a dependency manager for Ruby projects. Bundler is a Gem that, since Ruby version 2.5, comes installed with Ruby.

Dependency management is important in all programming languages, though the specific facilities vary. Handling dependencies is a significant issue for Ruby developers, who often need to manage multiple versions of Ruby, each with multiple versions of Gems.

While version managers like `RVM` and `rbenv` are useful for installing multiple different Rubies on a local system, developers need a tool that can assist in installing the particular version of each Gem needed by a project while avoiding dependency conflicts. Any given Gem can depend on many other Gems in order to function, and this can create complex dependency graphs, with the potential for version conflicts between Gems. This is where Bundler comes in.

Bundler handles the installation of components and ensures that compatible versions of each Gem required by a project are selected to work together. The `Gemfile` configuration file that Bundler uses describes the minimum and maximum versions of each Gem required by a project, and Bundler can use this information to determine the optimal selection of Gem versions. Once the `Gemfile` is written, we can easily distribute the project to other systems and be sure that the same combination of dependencies will be recreated there.

Thus, Bundler gives Ruby developers tools to describe and manage the dependencies for Ruby projects, making it easy to avoid dependency issues and to distribute the project to other systems.

Additionally, Bundler provides facilities that aid Ruby developers in packaging and distributing projects as Gems.

### Rake

Rake is a RubyGem installed with the Ruby installation that allows us to automate tasks required to build, test, package, release, and install Ruby programs. We can write Rake tasks to automate anything we need to for the development, testing, and release cycles of an application.

All useful Ruby projects involve repetitive tasks: running tests, building databases, packaging and releasing a new version of the project, and so on. Almost all Ruby projects make use of Rake for automation of these tasks, so it is important to be familiar with its use.

Many tasks associated with software projects involve steps that must be executed in a certain order, or involve operations where typos can have unfortunate consequences. Automation with Rake therefore ensures that the right steps are carried out in the right order, greatly reducing the opportunity for human error.

We define Rake tasks in the `Rakefile` in a project’s main directory. The `Rakefile` is written in Ruby code with the assistance of a DSL (Domain Specific Language).

Rake thus provides facilities to easily manage and run the repetitive tasks associated with a Ruby project, and allows us to describe these tasks using Ruby code.

## `Gemfile`

Bundler uses a text file called `Gemfile` as a configuration file for any given project. The `Gemfile` is written in a Ruby DSL (Domain Specific Language) and tells Bundler which version of Ruby and its Gems are required by the project.

A `Gemfile` generally consists of four parts. First, we need a `source` statement, which tells Bundler which remote library contains the RubyGems it needs to install. Normally, this will be `rubygems.org`.

If we are packaging our project as a Gem, we need to add a `gemspec` statement. This tells Bundler to search the project directory for a `.gemspec` file, which contains information needed to package and publish a Gem. Bundler will only search for a `.gemspec` file if we add this statement, and we only need a `.gemspec` file if we are creating a Gem.

A `ruby` statement tells Bundler which version of Ruby we are using. This is optional, but since most software projects standardize on a particular version of a programming language, it is recommended.

Finally, we use `gem` statements to describe the Gem dependencies that our project requires. We can specify version requirements using `>`, `<`, `>=`, and `<=` to give minimum and/or maximum versions. However, it is common to express version requirements using `~>` notation, which means ‘equal to or greater than in the last digit’.

When we execute `bundle install` from the command line, Bundler scans the `Gemfile`, downloads and installs the dependencies listed, and produces a file called `Gemfile.lock`. The `Gemfile.lock` file lists all the dependencies for the project, not only the Gems listed in the `Gemfile` but all of the Gems that they depend on too.

After we have run `bundle install`, we add `require 'bundler/setup'`  before any other `require` statements in the main program files of our project. This ensures that Bundler has control of Ruby’s `$LOAD_PATH` global array, which determines which directories Ruby searches to find dependencies loaded by `require` statements. This way, Bundler can remove the default directories and add the directories of the Gem versions listed in the `gemfile.lock`.

If we later add another Gem to the `Gemfile`, we must run `bundle install` again.

The purpose of the `Gemfile` is thus to describe the dependencies of a Ruby project for Bundler, so that the project can be recreated on other systems, whether for the systems of other developers working on the project or when the project is released.



