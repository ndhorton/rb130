1. What is a closure in Ruby? Provide an example.

A closure is a general programming concept that allows programmers to save a "chunk of code" to be passed around and executed later. A closure binds to the surrounding artifacts (such as local variables) at the point in our program where the closure is defined, "closing over" the surrounding context that the code chunk needs in order to be executed later.

We can think of closures as like anonymous methods, or anonymous functions, with an environment attached, which in Ruby is called the closure's "binding". Different languages implement closures differently, with varying levels of support. Some languages do not implement them at all.

In Ruby, we can implement a closure as a block, a Proc object, or a lambda.

Many of Ruby's core classes and modules have methods that make use of closures in the form of blocks. This example demonstrates how a block, passed in as implicit argument to the `Integer#times` method invocation, is able to access the `arr` local variable from the scope the block was created in, since the variable has become part of the block's binding:

```ruby
arr = [1, 2, 3, 4, 5]

arr.size.times do |index|
  arr[index] **= 2
end

p arr # [1, 4, 9, 16, 25]
```





2. Explain the concept of binding in relation to closures.

A closure retains access to the variables, constants, methods, and other artifacts it needs in order to be executed later that are in scope at the time and location in the program where the closure was created. We say that the closure creates a *binding*, or that the closure *binds* its code (its anonymous function) with the in-scope artifacts.

Closures bind to the local variables in scope at the time and location in the program where the closure is created. A local variable must be initialized before the closure is created for the closure to bind it. If a local variable that is bound by a Proc or lambda is reassigned another object after the Proc or lambda is created, that reassignment will be reflected by the Proc or lambda. The closure binds the variable itself, not the value of the variable.

A closure must keep track of its binding to have all the information it needs to be executed later (in a possibly different scope). This not only includes local variables, but also method references, constants, and other artifacts in the environment -- everything in the surrounding context that it needs to execute correctly.



3. What is the difference between a Proc and a lambda in Ruby?

The chief difference to be aware of between a normal Proc object and a lambda has to do with argument checking. We say that a lambda has 'strict arity', meaning that similarly to methods, lambdas insist that we pass the right number of required arguments when we call the lambda. If we don't, like with methods, we will raise an `ArgumentError` exception.

E.g.

```ruby
lamb = lambda do |a, b|
  if a > b
    "#{a} is greater than #{b}"
  else
    "#{a} is not greater than #{b}"
  end
end

p lamb.call(5, 3)  # "5 is greater than 3"
p lamb.call()      # raises ArgumentError
```

Ordinary Proc objects have what we call 'lenient arity',  meaning that a Proc will not raise an exception if we pass too many argument or too few. When we call a Proc, any parameters that do not receive an argument will simply be set to `nil`.

E.g.

```ruby
pr = Proc.new { |name| "my name is #{name}" }

puts pr.call("Dave")  # "my name is Dave"}
puts pr.call("Mike", "Jones")  # "my name is Mike"
puts pr.call()	# "my name is "
```



4. Consider the following code: 

```
# ruby

   def execute(&block)
     block.call
   end
   
   execute { puts "Hello from the block!" }
   
```

 What will this code output and why?



This code will output `"Hello from the block!"`. The reason has to do with the unary `&` operator prefixed to the `execute` method parameter `block`.

On line 7, we call the `execute` method was a `{ ... }` block passed as implicit argument.

The `execute` method is defined on lines 3-5 with one parameter `block`. Prepended to this parameter is the `&` operator. The `&block` parameter is an explicit block parameter, allowing blocks to be explicitly passed as argument and assigned to a method-local variable like any other positional argument. If we use an explicit block parameter, it must be the last parameter in the list. If a block is not passed when the method is invoked, the explicit block parameter will be assigned `nil`.

What the `&` operator does in this context is to convert the given block into a Proc object. This means that within the method definition, `block` references a new Proc object defined by the block passed to the method invocation, which can be passed around or returned like any other object.

Within the method definition body, on line 4, we call `Proc#call` on `block`. We are able to do this because the block we passed to `execute` has been converted to a Proc.

Execution jumps to the code defined by the block definition on line 7, where the string `"Hello from the block!"` is passed to `Kernel#puts` and output to the screen.

This example demonstrates the use of the `&` operator for explicit block parameters, which involve block-to-Proc conversion.





5. What is the purpose of the `&` symbol when used as a method parameter?

The purpose of the `&` operator when prefixed to a method parameter is to denote an explicit block parameter.

For example,

```ruby
def call_using_call(&block)
  block.call if block
  block
end

pr = call_using_call { puts "hi there" }  # "hi there"
pr.call  # "hi there"
```

On line 6, we initialize local variable `pr` to an invocation of the `call_using_call` method with a block `{ puts "hi there" }`.

The `call_using_call` method is defined on lines 1-4 with an explicit block parameter `&block`. The `&` operator used in this context converts the block passed to the method to an ordinary Proc object. Thereafter, the Proc referenced by the method-local variable can be passed around or returned like any other object.

Within the method definition body, on line 2, an `if` statement checks the truthiness of the `block` method-local variable. When an explicit block parameter does not receive a block argument, no exception is raised, the parameter is simply assigned `nil`. So here, we first test that a block has been passed. Since it has, and `block` references a Proc object, which is truthy, we call `Proc#call` on `block`.

Execution jumps to the code defined by the block definition on line 6. We pass the string `"hi there"` to `Kernel#puts` to be output to screen.

Execution resumes in the method definition on line 3, where we restate `block` as the implicit return value of `call_using_call`, which means the Proc object is returned to be assigned to `pr` on line 6. This is perfectly fine, since our block is now a Proc object.

We demonstrate this on line 7 by again calling `call` on the Proc referenced by `pr`, which again outputs `"hi there"` to the screen.



6. Explain the concept of arity in relation to blocks and methods.

Blocks (and Procs) are said to have 'lenient arity' in relation to their arguments, and methods (and lambdas) have 'strict arity'.

Lenient arity means that a block does not care if too many or too few arguments are passed with respect to the block's parameters. Any excess arguments are ignored, and if a parameter does not receive a corresponding argument, the parameter is simply assigned `nil`. No exception will be raised regardless of how many arguments are passed. For example,

```ruby
def pass_two_args
  yield(1, 2)
end

pass_two_args { |a, b, c| puts "a = #{a} and b = #{b} and c = #{c.inspect}" }
# => "a = 1 and b = 2 and c = nil"
pass_two_args { |a, b| puts "a = #{a} and b = #{b}" }  # "a = 1 and b = 2"
pass_two_args { |a| puts "a = #{a}" }  # "a = 1"
pass_two_args { puts "both arguments ignored" } # "both arguments ignored"
```

Methods have strict arity, which means we must pass exactly the right number of required parameters or an `ArgumentError` will be raised. For example,

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



7. How does local variable scope work with blocks in Ruby?

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



9m50s



8. What is the difference between `block_given?` and an explicit block parameter?

Any method can take an implicit block. The method can be defined to interact with an implicit block via the `yield` keyword and the `Kernel#block_given?` methods. `block_given?` returns `true` if a block has been implicitly passed to the method at invocation, `false` otherwise. It is usually used in an `if` conditional check which guards the use of the `yield` keyword, since using `yield` when no block has been passed at invocation time will raise a `LocalJumpError` exception.

An explicit block parameter is a always the last parameter in a parameter list and is denoted by a `&` prefix (though when we reference the parameter within the body of the definition, we do not prefix it with `&`). The `&` operator used in this context will convert a block passed to the method to an ordinary Proc object. If no block is given, the parameter will be assigned `nil`. Thus, if we wish to test whether a block has been passed, we can check the truthiness of the explicit block parameter (as well as using `block_given?`).

An explicit block parameter can be used when we wish to have the block as a (Proc) object that we can pass around to other methods, or even return, like any other object. We can execute the explicit block using `Proc#call` like any other Proc object.



9. Describe the SEAT approach in testing. What does each letter stand for?

The SEAT approach in testing breaks down writing a test into four main steps, each of which is denoted by a letter in the acronym SEAT.

S stands for Setup. This step involves setting up the necessary objects for a test case; these are commonly assigned to instance variables to be used in within the test cases. In Ruby's Minitest framework, we can extract any setup common to all of the test cases in a test class to a `#setup` method. The `#setup` method is automatically called before each test method in the class is run.

T stands for Teardown. This final step involves tearing down and cleaning up any lingering artifacts, such as open files, database handles, and so on. In Ruby's Minitest framework, we can extract teardown operations common to all test cases in a test class to a `#teardown` method. The `#teardown` method is called automatically after each test method has finished executing.

`#setup` and `#teardown` are both optional, and we can define one without the other.

E stands for Execute. This necessary step involves executing the code we wish to test against the objects being tested. All test cases will involve an execute step.

A stands for Assert. This step is the actual test step. We assert the code we just executed has behaved as expected. We assert, using one of Minitest's many assertions, that the actual result of the Execute step conforms to our expectations. All tests involve this step.

7m57s



10. What is the difference between Minitest and RSpec?

Minitest is part of the Ruby standard library whereas RSpec is not. Minitest is a bundled gem, meaning it is installed with the Ruby installation as the default Ruby testing library, though it can be uninstalled if necessary. RSpec is a normal gem that must be deliberately installed.

In terms of basic functionality, Minitest can do anything RSpec can do. However, Minitest has a straightforward default syntax that is largely just Ruby code. RSpec is a Domain Specific Language designed to allow us to write tests that read more like English.

While Minitest can optionally use a DSL, the standard Minitest syntax is for the most part standard Ruby syntax. This can make writing and understanding Minitest tests simpler than in RSpec, especially for beginner developers.

Minitest's standard syntax is assert-style (or assertion-style) syntax. Minitest's optional DSL allows us to write spec-style (or expectation-style) syntax, which is similar to RSpec's syntax. Spec-style syntax might read more like English natural language, but it requires learning more new (and somewhat opaque) syntax to achieve this.

Minitest does not have all the flexibility and power of RSpec but it does have all the functionality necessary for most testing scenarios.



11. Write a basic test case using Minitest's assert-style syntax to check if a method returns the expected value.

```ruby
require 'minitest/autorun'

class Cat
  def speak
    "meow"
  end
end

class CatTest < Minitest::Test
  def test_cat_can_speak
    cat = Cat.new
    assert_equal "meow", cat.speak
  end
end
 
```



12. What is the purpose of the `setup` method in Minitest?

Most test cases involve a setup step. We need to set up necessary objects, whose methods and states we are testing.

In Ruby's Minitest framework, we can extract any set up actions common to all of the test cases in a test class to a `#setup` method. The `#setup` method is automatically called before each test method in the class is run. We usually assign these necessary objects to instance variables that can then be used in our test methods.

The purpose of extracting code to the `#setup` method is to avoid repetition of common code, bringing the advantages that DRY code usually does. We have less of a surface area for bugs and mistakes in our tests, meaning we are less likely to introduce errors and we will have an easier time debugging if we do make a mistake.



13. Explain the difference between `assert_equal` and `assert_same` in Minitest.

In Ruby's Minitest testing framework, `assert_equal` tests for value equality while `assert_same` tests for object equality.

The `assert_equal` assertion is one of the most commonly used assertions. The kind of equality asserted by `assert_equal(expected, actual)` is value equality, or equivalence of states. The method it uses to compare the `expected` object with the `actual` object is the `==` method, which returns `true` if the caller and argument have an equivalent representative object value (`false` otherwise). `assert_equal` fails unless `expected == actual`. This means that an appropriate `==` method must be defined for the objects being asserted against.

The other form of equality we may wish to assert is object equality. For this we use the `assert_same` assertion. When we use `assert_same(expected, actual)`, we are testing whether the object referenced by `expected` is the same object with the same object id as the object referenced by `actual`; `assert_same` will fail unless this is the case. `assert_same` uses the `equal?` method to test for object equality, usually inherited from `BasicObject`.

So `assert_equal` checks for value equality between two (potentially) different objects, and `assert_same` checks for object equality between two variables.



14. How would you test for an exception being raised in Minitest?

In Minitest, we test for expected exceptions being raised by the code we are testing by using `assert_raises`.

The arguments to `assert_raises` should be the exception or exceptions we expect to be raised. We then define the code we wish to test within a block defined on the invocation of `assert_raises`. For example,

```ruby
require 'minitest/autorun'

class ZeroUndefinedTest < Minitest::Test
  def test_zero_is_undefined
    assert_raises(ZeroDivisionError) do
      1 / 0
    end
  end
end
```



15. What is code coverage, and why is it important in testing?

Code coverage refers to how much of a program's code is tested by a test suite: both the public and private code. To achieve 100% code coverage, we need to ensure that all public and private methods and all paths of branching logic are tested by our test suite. However, 100% code coverage does not mean that every possible edge case is considered by these tests; it does not even mean the program as a whole is operating correctly. Thus, code coverage is simply one metric that you can use to gauge code quality.

Code coverage is important because it is a metric that demonstrates that every branch of logic in the code our test suite is testing has been exercised.

16. What is the purpose of a Gemfile?

The `Gemfile` forms part of most Ruby projects. It is used by the Bundler gem.

Bundler is a dependency manager for Ruby projects. Bundler is a gem that, since Ruby version 2.5, comes installed with Ruby.

Dependency management is important in all programming languages, though the specific facilities vary. Handling dependencies is a significant issue for Ruby developers, who often need to manage multiple versions of Ruby, each with multiple versions of gems.

Any given Gem can depend on many other Gems in order to function, and this can create complex dependency graphs, with the potential for version conflicts between Gems. This is where Bundler comes in.

 Bundler handles the installation of components and ensures that compatible versions of each Gem required by a project are selected to work together. The `Gemfile` configuration file that Bundler uses describes the minimum and maximum versions of each Gem required by a project, and Bundler can use this information to determine the optimal selection of Gem versions. Once the `Gemfile` is written, we can easily distribute the project to other systems and be sure that the same combination of dependencies will be recreated there.

The `Gemfile` is written in a Ruby DSL (Domain Specific Language) and tells Bundler which version of Ruby and its Gems are required by the project.

A `Gemfile` generally consists of four parts. First, we need a `source` statement, which tells Bundler which remote library contains the RubyGems it needs to install. Normally, this will be `rubygems.org`.

If we are packaging our project as a Gem, we need to add a `gemspec` statement. This tells Bundler to search the project directory for a `.gemspec` file, which contains information needed to package and publish a Gem. Bundler will only search for a `.gemspec` file if we add this statement, and we only need a `.gemspec` file if we are creating a Gem.

A `ruby` statement tells Bundler which version of Ruby we are using. This is optional, but since most software projects standardize on a particular version of a programming language, it is recommended.

Finally, we use `gem` statements to describe the Gem dependencies that our project requires. We can specify version requirements using `>`, `<`, `>=`, and `<=` to give minimum and/or maximum versions. However, it is common to express version requirements using `~>` notation, which means ‘equal to or greater than in the last digit’.

When we execute `bundle install` from the command line, Bundler scans the `Gemfile`, downloads and installs the dependencies listed, and produces a file called `Gemfile.lock`. The `Gemfile.lock` file lists all the dependencies for the project, not only the Gems listed in the `Gemfile` but all of the Gems that they depend on too.

The purpose of the `Gemfile` is thus to describe the dependencies of a Ruby project for Bundler, so that the project can be recreated on other systems; these might be the systems of other developers working on the project or those of users when the project is released.



17. Explain the difference between `require` and `require_relative` in Ruby.

The `Kernel#require` method searches for the package passed as a string argument. `require` searches in the directories determined by the Ruby installation, RubyGems, and potentially Bundler and the `Gemfile`.

Although `Kernel#require_relative` also searches for a given package, it accepts a full pathname as the string argument. If we use a relative pathname, it searches in relation to the directory of the requiring file.

For instance, if we have a project directory `~/my_project` containing a `lib` directory where our Ruby code files are, and a `test` directory where our Minitest tests are, then a `require_relative` call in one of those test files might look like this:

```ruby
require 'minitest/autorun'

require_relative '../lib/my_cool_class.rb'

class MyCoolClassTest < Minitest::Test
  # code omitted ...
end
```



18. What is Bundler, and why is it useful in Ruby projects?

Bundler is a dependency manager for Ruby projects. Bundler is a Gem that, since Ruby version 2.5, comes installed with Ruby.

Dependency management is important in all programming languages, though the specific facilities vary. Handling dependencies is a significant issue for Ruby developers, who often need to manage multiple versions of Ruby, each with multiple versions of Gems.

While version managers like `RVM` and `rbenv` are useful for installing multiple different Rubies on a local system, developers need a tool that can assist in installing the particular version of each Gem needed by a project while avoiding dependency conflicts. Any given Gem can depend on many other Gems in order to function, and this can create complex dependency graphs, with the potential for version conflicts between Gems. This is where Bundler comes in.

Bundler handles the installation of components and ensures that compatible versions of each Gem required by a project are selected to work together. The `Gemfile` configuration file that Bundler uses describes the minimum and maximum versions of each Gem required by a project, and Bundler can use this information to determine the optimal selection of Gem versions. Once the `Gemfile` is written, we can easily distribute the project to other systems and be sure that the same combination of dependencies will be recreated there.

Thus, Bundler gives Ruby developers tools to describe and manage the dependencies for Ruby projects, making it easy to avoid dependency issues and to distribute the project to other systems.

Additionally, Bundler provides facilities that aid Ruby developers in packaging and distributing projects as Gems.

19. How would you use the `&:symbol` shorthand in Ruby? Provide an example.

In the context of passing an argument to a method invocation, prefixing the argument with the unary `&` operator will signify to Ruby that we are attempting to convert that object to a block to be passed implicitly to the method as we would an ordinary block definition.

For Proc objects this is straightforward. However, we can also prefix `&` to a Symbol argument, and the `&` operator will call the `Symbol#to_proc` method.

Unary `&` used in this way implicitly calls `#to_proc` on the argument before attempting conversion to a block. If the object is a Proc, `Proc#to_proc` simply returns the caller, and the Proc is converted to a block. If the object is a symbol, `Symbol#to_proc` will be called. (If the object does not have a `to_proc` method, a `TypeError` will be raised.)

`Symbol#to_proc` is designed to assume that the Symbol it is called on is the name of a method. So if, for instance, `to_proc` is called on the symbol `:to_s`, it will return a Proc whose code would be equivalent to:

```
 { |object| object.to_s }
```

The unary `&` operator then converts this Proc object to a block to be implicitly passed to the method call.

This technique is only useful for certain kinds of methods. The Proc produced by `Symbol#to_proc` will always take the form given above. Consequently, this technique is not useful for methods that require us to pass arguments. However, it is very useful shorthand when we wish to call the same method with no arguments in a block passed to an iterator method such as `Array#map`.

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

20. Consider the following code:

```
# ruby

    def my_method
      yield(2) if block_given?
    end
    
    my_method do |x|
      puts x * 3
    end
    
```

  What will this code output and why?

On line 7, we call the `my_method` method with a block defined over lines 7-9.

The `my_method` method is defined on lines 3-5. Within the body of the definition, on line 4, the `Kernel#block_given?` method is used as an `if` condition to check if a block has been passed to the method. Since on this invocation we did pass a block, `block_given?` returns `true` and the `yield` keyword calls the block with the integer `2` passed as argument.

Execution jumps to the block defined on lines 7-9. The block parameter `x` is assigned the integer argument `2`.

Within the bod of the block, on line 8, we multiply `x` by `3` and pass the return value to `Kernel#puts` to be output to screen: `6`. Since `puts` is the last expression in the block, the block returns `nil`.

Execution passes back to the `my_method` method, and since there is no more code in the definition, the method also returns `nil`.

4m42s