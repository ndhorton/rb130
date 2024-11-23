<u>Testing terminology</u>

2:1 and Quiz

The default Ruby testing library is Minitest.

Regression tests:

* [Definition] Regression tests check for bugs that occur in formerly working code after you make changes somewhere in the codebase.
* [Benefits] Using tests to identify these bugs means we don't have to verify that everything works manually after each change. 
* As beginners, we write tests to prevent regression -- that's it. That's the only benefit of testing we'll focus on for now.

Unit testing

"If you must give a name to what we're going to cover, you can think of this as learning *unit testing*"

'This' being "testing... classes"

* Unit tests check the specific functionality of a small piece (or unit) of code. They test that unit in isolation to ensure it works.



2:3 : Minitest

"Though many people use RSpec, Minitest is Ruby's default testing library and is part of Ruby's standard library. More specifically, it's a bundled gem, which means Minitest is shipped with the default Ruby installation, but is maintained outside the Ruby core team and can be uninstalled if necessary."



Minitest is a (bundled) gem. Can't remember if it needs to be added to a gemfile, given that we run the tests separately from the app.

Vocabulary:

* Test Suite: this is the entire set of tests that accompanies your program or application. You can think of this as *all the tests for a project*.
* Test: this describes a situation or context in which tests are run. For example, this test is about making sure you get an error message after trying to log in with the wrong password. A test can contain multiple assertions.
* Assertion: this is the actual verification step to confirm that the data returned by your program or application is indeed what is expected. You make one or more assertions within a test.

We `require 'minitest/autorun` to load all the necessary files from the `minitest` gem. We `require_relative` the file(s) that we are testing. 

We create test classes in Minitest that subclass from `Minitest::Test`. This means they will inherit all the functionality needed to write tests.

In Minitest, an individual test is an instance method whose name must begin with `test_`. This naming convention lets Minitest know that the method is a test that needs to be run. Within a test (instance method) we can make one or more assertions. Assertions like `assert_equal` are inherited instance methods from somewhere up the class hierarchy of `Minitest::Test`, the immediate superclass of our test class.

Seeds: the 'seed' number given in the Minitest output describes the order in which the randomized tests were executed on this particular run. If we give this seed to Minitest on the next run, the tests will be run in the same exact order as on this occasion. This is rarely used but can aid in debugging where a particularly tricky bug only appears in highly specific situations.

The tests are represented by characters below this, with a `.` meaning a test has passed, an `S` meaning a test was skipped, and an `F` meaning a test has failed. There is also `E` which designates an Error. These seem to generally signify exceptions that Minitest rescues in order to keep running tests, which get logged and reported in the final output. They can be caused by forgetting to include the test file, missing classes, missing methods, etc.

We can skip tests with the `skip` keyword. We can pass a string to `skip` if we want a custom message displayed in the final output.

"Sometimes you'll want to skip tests. Perhaps you are in the middle of writing a test, and do not want it run yet, or for any other reason. Minitest allows for this via the `skip` keyword. All you have to do is put `skip` at the beginning of the test, and Minitest will skip it. It will also dutifully report that you have skipped tests in your suite, and output an "S" instead of a dot."

Uses I've seen: skipping unfinished tests that will fail unproductively (i.e. not because of deficiencies in the unit but in the test); and when tests are used to give requirements that the class we are developing needs to fulfill. In the second case, this makes it easier to add in tests to test methods of the class as we write them without the Minitest output becoming cluttered with failed tests or errors.

2:4: Article

* A **test step**, or simply, a **test**, is the most basic level of testing. A test step simply verifies that a certain expectation has been satisfied... Test steps employ either an assertion or an expectation, depending on your testing framework. [In lesson 2:3, this maps to "assertion" rather than "test"]
* A **test case** is a set of actions that need to be tested combined with any appropriate test steps. This may include instantiation of an object, calling methods on it, and then making an assertion to verify the expected results. Typically, only one test step is used per test case; some developers insist on this, others are more flexible.
* A **test suite** is a collection of one or more test cases that, taken together, demonstrate whether a particular application facet is operating correctly. We use this term quite loosely: a test suite can test an entire class, a subset of a class, or a combination of classes, all the way up to the complete application.



So assertions and expectations are test steps. The methods we wrap assertions in are test cases. The Minitest files we write are test suites. Test suite might also refer to a test class in Minitest terms. Test suite could mean multiple test files that test an entire app.



"As you can see, assertions are little more than basic Ruby code: all you need to know is what modules to require; how to name your classes (test suites) and methods (test cases); and the methods (assertions) you need to call to perform each test [step]. On the other hand, expectations have a DSL that needs to be learned, with commands like `describe` and `it`, and those odd `must_*` methods being applied to the return values... The DSL is more English-like, but you still need to learn the DSL even if you know English."

This is about Minitest expectations, but the point about the DSL is true for RSpec too.

* Typically, test suites are stored in a special `tests` directory beneath your main application's development directory. This isn't a requirement, but it is good practice for source organization, particularly when working with large projects. [From what I can see `test` without the 's' is at least as common in popular projects on Github. `spec` is most common, but that is when RSpec is used.]
* There are no universal conventions regarding how to name your test suites. In the absence of any rules imposed by projects guidelines, we recommend establishing your own naming conventions and sticking to them; for instance, a common convention is to name a test suite for a class named `Todo` as `t_todo.rb` or `todo_test.rb`.

Requiring `minitest/autorun` gives you everything you need to run most basic tests and ensures that all of the tests in your test suite will be run automatically when you run the test suite.

* We use `require_relative` to require the file we need to test, and the file's path will be relative to the directory of the test file.

* We then define a class that inherits from `Minitest::Test`. This class defines the test suite -- a collection of one or more test cases. The name of this class is not important; however, it is common to append or prepend `Test` to the name, and the rest of the name is often the name of the class or module being tested. What's important to Minitest is that the class inherits from `Minitest::Test`; Minitest runs tests in every class that inherits from `Minitest::Test` [when the test file is executed].

* Each test case is represented by a method whose name begins with `test_`; this is required. Minitest looks for and runs all methods in the test suite [class] whose name begins with `test_`. The rest of the method name is usually a short description of what we are testing.

Every assertion-based Minitest test suite you set up will look like this. Some test suites may have multiple test suite classes defined in the file.


It's important to understand how testing fits into the software development cycle. Ideally, your test cases should be run before writing any code. This is frequently called Test-Driven Development (TDD). It follows a simple pattern:

1. Create a test that fails.
2. Write just enough code to implement the change or new feature
3. Refactor and improve things, then repeat tests

This is often called Red-Green-Refactor. Red describes the failure step; green describes the getting things working; and, of course, refactor covers refactoring and improving things.



In order to run tests in the specific order of a previously generated seed, we must pass `--seed [number]` to Ruby on the command line.

In order to determine ourselves what order the tests are run, we must name all methods in alphabetical order and include the command `i_suck_and_my_tests_are_order_dependent!`. Don't do this.

Almost all assertions and refutations allow an optional message as the final argument to the assertion method. The exceptions to this are:

* `assert_mock`
* `assert_raises`
* `assert_silent`



`assert_in_delta(expected, actual, delta)` - this method is for testing floating point return values. Since floating point numbers are notoriously approximate, it is inadvisable to test for exact values. Instead, `assert_in_delta` allows us to test if a number is near an expected value, with the `delta` parameter allowing us to specify the acceptable distance between the expected and actual values.

`assert_silent { ... }` - fails if there is any output from the block to either stdout or stderr.

`assert_output(stdout_output, stderr_output=nil) { ... }` - if we pass a string argument, fails unless the outputs to stdout/stderr within the block match the argument(s) exactly (including newlines). If we pass a regex argument, fails unless the actual output matches the expected pattern.

If we only wish to test stdout, we can leave out the second argument. If we only wish to test stderr, we need to pass `nil` as the first argument.



The Minitest failure messages are in the unified format of diff. The 'hunks' of mismatch between expected and actual begin with `@@ -l,s +l,s @@`, where `l` is the start line of the output and `s` is the number of lines that are problematic. `-l,s` is the range of expected output being compared and `+l,s` is the range of actual output being compared.

```
In stdout.
--- expected
+++ actual
@@ -1 +1,2 @@
-""
+"foo
+"
```

Here, we expected an empty string/line (written to stdout), and instead got `"foo\n"` (written to stdout as line 1 of the output of the block and extending over 2 lines). The newline is displayed as an actual new line.

`capture_io { ... }` - lets us retrieve the output of both streams as strings, against which we might make multiple assertions. For example,

```ruby
def test_stdout_and_stderr
  out, err = capture_io do
    print_all_records
  end
  
  assert_equal '', out
  assert_match /No records found/, err
end
```



`assert_instance_of(Class, object)` - fails unless `object` is an instance of `Class`, equivalent to `Object#instance_of?`

`assert_kind_of` - equivalent to `Object#kind_of?` or `Object#is_a?`

`assert_respond_to(method_symbol)`  - equivalent to `Object#respond_to?`. The argument will be the name of a method as a Symbol

We can put a conditional on startup code like so

```ruby
Xyzzy.new.run if __FILE__ == $PROGRAM_NAME
```

or

```ruby
Xyzzy.new.run if __FILE__ == $0
```

If you run the program directly, both `__FILE__` and `$PROGRAM_NAME`/`$0` reference the program file. If instead you require the file into your test module, `$PROGRAM_NAME` and `$0` will be the name of the test program file, but `__FILE__` will continue to refer to the main program file; since the two names differ, the launch code will not run.



2:8 Code coverage

"When writing tests, we want to get an idea of **code coverage**, or how much of our actual program code is tested by a test suite. You can see from our `TodoList` tests that all of our public methods are covered. If we are measuring code coverage based on testing the public methods, we could say that we have achieved 100% code coverage. Note that even though we are only testing public code, code coverage is based on all of your code, both public and private. Also, this doesn't mean every edge case is considered, or even that our program is working correctly. It only means that we have some tests in place for every method. There are other ways to measure code coverage too besides looking at public methods. For example, more sophisticated tools can help with ensuring that all branching logic is tested. While not foolproof, code coverage is one metric that you can use to gauge code quality."

* Code coverage means how much of our actual program code is tested by a test suite.

* Code coverage is based on all of your code, both public and private. 
* 100% code coverage can be achieved by ensuring that all methods, both public and private, and all paths of branching logic are exercised by the tests
* Nevertheless, 100% code coverage does not mean that every edge case or conceivable eventuality has been considered by the tests, nor that the program is even working as a whole.
* While not foolproof, code coverage is one metric that you can use to gauge code quality.

Quiz:

"Code coverage is a measure of how much of a program is tested by a test suite"

"Code coverage can be used as a metric to assess code quality" - ???? What??? How did I get this right the first time?

Ok, I assume it means that if we have 100% code coverage *and our tests are passing*, this is a strong indicator that the code we are testing is sound. If we only have 50% coverage, we have much less information on how sound our overall program code is, since some of it is essentially untested. I think this is what it means.

"Also, this doesn't mean every edge case is considered, or even that our program is working correctly"

So this means that we may have a test that exercises a method, and the test passes. But that might only test how the method behaves with a 'happy path' input. And we might only be testing it in isolation. But in the total program, it might get fed reasonable values that it does not behave well with. So 100% code coverage only means that every line of code gets exercised by the tests, not that every conceivable eventuality has been foreseen and tested.



<u>Minitest vs. RSpec</u>

2:1: Introduction

"What this lesson will NOT talk about: ... RSpec"

2:3

"Though many people use RSpec, Minitest is Ruby's default testing library and is part of Ruby's standard library. More specifically, it's a bundled gem, which means Minitest is shipped with the default Ruby installation, but is maintained outside the Ruby core team and can be uninstalled if necessary."

ASIDE

from stdgems.org: About Ruby's Gemified Standard Library

"Large portions of Ruby's standard library come int the form of RubyGems, which can be updated independently from Ruby. There are two kinds of standard gems"

"Default gems: these gems are part of Ruby and you can always require them directly. You cannot remove them. They are maintained by Ruby core"

" Bundled gems: the behavior of bundled gems is similar to normal gems, but they get automatically installed when you install Ruby. They can be uninstalled and they are maintained outside of Ruby core"

"There are a few libraries that will stay non-gem default libraries, because they are very dependent on the specific Ruby version"

END ASIDE

"**From a purely functional standpoint, Minitest can do everything RSpec can**. However, **Minitest provides a simpler and more straightforward syntax**. RSpec bends over backwards to allow developers to write code that reads like natural English, but at the cost of simplicity. *RSpec is what we call a* **Domain Specific Language**; it's a DSL for writing tests. Minitest can also use a DSL, but it can also be used in a way that reads like ordinary Ruby code without a lot of magical syntax. This simpler style isn't a DSL, it's just Ruby.

* Minitest can do anything RSpec can do
* Minitest is part of the Ruby standard library, while RSpec is not. Minitest is a bundled gem, meaning it is installed with the Ruby installation as the default Ruby testing library, though it can be uninstalled if necessary. RSpec is a normal gem that must be deliberately installed by the user.
* RSpec is a Domain Specific Language designed to allow us to write tests that read very much like natural English. While Minitest can optionally use a DSL, the standard Minitest syntax is for the most part standard Ruby syntax. This can make writing and understanding Minitest tests simpler than in RSpec, especially for beginners.

2:3: Minitest

Minitest's default syntax is **assertion** or **assert-style** syntax. 

Minitest also permits us to use **expectation** or **spec-style** syntax if we wish. This is purely a style choice. RSpec users may prefer it since it mimics RSpec's syntax.

"In expectation style, tests are grouped into `describe` blocks, and individual tests are written with the `it` method. We no longer use assertions, and instead use **expectation matchers**."

The expectation syntax is an optional DSL, which reads like standard English but doesn't look like 'normal' Ruby syntax. It is also much less clear where methods like `describe` and `it` and especially the construction `_().must_equal` are coming from.

I should note here that the 'Spec' in 'RSpec' might stand for specification rather than expectation. It's probably best to say that Minitest expectation style mimics RSpec's syntax and leave it at that.

"Minitest comes in two syntax flavors: assertion style and expectation  style. The latter is to appease RSpec users, but the former is far more  intuitive for beginning Ruby developers."





2:4: Article

"Minitest ... is not quite as powerful and flexible as its cousin RSpec, but for most cases, Minitest will do everthing you need"



<u>SEAT Approach</u>

2:3 : Minitest

"Before we make any assertions, however, we have to first set up the appropriate data or objects to make assertions against". The example here is an object instantiated within a test method. I'm not sure if instantiating an object within a test method counts as part of the Setup or as part of the Execute part of SEAT (or neither?)

2:5: SEAT Approach

* In larger projects, there are usually 4 steps to writing a test:

1. Set up the necessary objects
2. Execute the code against the object we're testing
3. Assert that the executed code did the right thing
4. Tear down and clean up any lingering artifacts

The `#setup` method is called before every test and the `#teardown` method is called after every test. Both are optional and neither method requires the other to be defined.

The Setup step commonly instantiates objects and assigns them to instance variables. The Teardown step might close files, log information, close database connections, and so on.

Even if we cannot make good use of a `#setup` or `#teardown` method, these four steps still characterize the necessary steps to running any test:

1. We generally need to instantiate objects or setup values even if we need to do so differently for each test case
2. We are always testing the execution of some action on some kind of object or value
3. We always need a test step
4. if nothing else, Ruby's garbage collection handles the teardown (destruction) of objects used in the test, even if it does so automatically and without programmer intervention

At the minimum we need to do E and A ourselves, even if E is just object instantiation and we are Asserting that the object exists.

* Minitest calls `#setup` method before, and `#teardown` method after, each test. These automatically perform any preprocessing or postprocessing needed. It is common to set instance variables in `#setup` that can be used in the test case methods. You can have define method without the other, and neither are required.



Benefits of `#setup` and `#teardown` methods

* Reduces redundancy. We save on the lines of code we need to write by removing duplication. This has the usual advantages of DRY code: less surface area for potential bugs means less likelihood of making a mistake and an easier time debugging if we do.





<u>Testing Equality</u>

2:3: Minitest

 `assert_equal` takes two parameters: the first is the expected value, and the second is the test or actual value. If there's a discrepancy, `assert_equal` will save the error and Minitest will report that error to you at the end of the test run.



2:4:Article

Typically, `#assert` is used with methods that return `true` or `false`. However, `#assert` has very unhelpful failure messages, so when using it we want to specify a custom message. Therefore, more often, `#assert` is simply not used. Instead, we use `#assert_equal` with an explicit `true` or `false` value, since this gives us a more meaningful default message.

The most frequently used assertion is `assert_equal`. It tests whether an actual value produced during a test is equal to an expected value.

`assert_equal` uses the `==` method to perform its comparisons. If an appropriate `==` method has not been defined, the default `BasicObject#==` will be used, which only returns `true` if the two objects being compared are the same object.

If the expected and actual objects are equal, meaning the `==` method returns `true`, then the test passes; otherwise, it fails. It is important to remember that if we are using `assert_equal` to test if a method returns `true`, the method must actually return that boolean object. Truthiness alone will not be enough. The same goes for `false`: `nil` will not pass the test.

`assert_same` checks whether two object arguments represent the exact same object. This is most useful when you need to verify that a method returns the same object is was passed. `assert_same` uses the `equal?` method instead of `==`. The `equal?` method returns `true` if the caller is the same object as the argument, with the same object id.

In general,  `assert_same` tests that the expected and actual object are the same object, while `assert_equal` tests whether expected and actual objects have equivalent states.



2:6: Testing Equality

When we use `assert_equal` we are testing for **value equality** or **equivalent states**. Specifically, we are invoking the `==` method on the object.

If we are looking for more strict **object equality**, then we need to use the `assert_same` assertion. 

If we are going to use `assert_equal`, we must be sure that any objects used as arguments to this assertion method implement a `==` method.







<u>Assertions</u>

2:3: Minitest

* Assertion: this is the actual verification step to confirm that the data returned by your program or application is indeed what is expected. You make one or more assertions within a test.

`assert_equal` takes two parameters: the first is the expected value, and the second is the test or actual value. If there's a discrepancy, `assert_equal` will save the error and Minitest will report that error to you at the end of the test run.



2:4: Assertions

"`assert_equal` is the most common assertion"

`assert(test)` fails unless `test` is truthy

`assert_equal(expected, actual)` fails unless `expected == actual`

`assert_nil(object)` fails unless `object` is `nil`

`assert_raises(*expected) { ... }` fails unless block raises one of the exceptions in `*expected`, note that the assertion is `assert_raises` with an `s`, unlike the keyword used to raise an exception

 `assert_instance_of(class, object)` fails unless `object` is an instance of `class`

`assert_includes(collection, object)` fails unless `collection.include?(object)`, note that the assertion is called `assert_includes` with an `s`, unlike the underlying predicate method



`assert_instance_of` is most useful when dealing with inheritance, since `instance_of` checks for the specific class of the object, not that it inherits from a common superclass, unlike `kind_of`

`assert_includes` calls the `assert` method twice behind the scenes. This means that for each `assert_includes` call, you will get 2 assertions [listed in the final Minitest output], not 1. This also applies to `refute_includes` as well as `assert_empty`, `assert_match`, and their refute counterparts. This oddity can be safely ignored.

Refutations

Refutations are the logical opposite of assertions. That is, they refute rather than assert. Every assertion has a corresponding refutation. For example, `assert`'s opposite is `refute` and fails unless the object that you pass it is falsey. Refutations all take the same positional arguments and blocks as their assertion counterparts.



