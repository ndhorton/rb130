### Testing terminology

* Test Suite: this is the entire set of tests that accompanies your program or application. You can think of this as *all the tests for a project*.
* Test: this describes a situation or context in which tests are run. For example, this test is about making sure you get an error message after trying to log in with the wrong password. A test can contain multiple assertions.
* Assertion: this is the actual verification step to confirm that the data returned by your program or application is indeed what is expected. You make one or more assertions within a test.

or a variation, with slight contradictions to the first set:

* A **test step**, or simply, a **test**, is the most basic level of testing. A test step simply verifies that a certain expectation has been satisfied... Test steps employ either an assertion or an expectation, depending on your testing framework. [In lesson 2:3, this maps to "assertion" rather than "test"]
* A **test case** is a set of actions that need to be tested combined with any appropriate test steps. This may include instantiation of an object, calling methods on it, and then making an assertion to verify the expected results. Typically, only one test step is used per test case; some developers insist on this, others are more flexible.
* A **test suite** is a collection of one or more test cases that, taken together, demonstrate whether a particular application facet is operating correctly. We use this term quite loosely: a test suite can test an entire class, a subset of a class, or a combination of classes, all the way up to the complete application.



#### Code Coverage

Code coverage refers to how much of a program's code is tested by a test suite: both the public and private code. To achieve 100% code coverage, we need to ensure that all public and private methods and all paths of branching logic are tested by our test suite. However, 100% code coverage does not mean that every possible edge case is considered by these tests; it does not even mean the program as a whole is operating correctly. Thus, code coverage is simply one metric that you can use to gauge code quality.



#### Regression Tests

We use regression tests to check for bugs that occur in formerly working code after we make a change to the codebase. The use of regression tests means that we don't need to verify manually that everything is working after each change.

#### Unit Tests

Unit tests check the specific functionality of a small piece, or unit, of code. For instance, this might be a class or a module. We test the unit in isolation to verify that it operates correctly.



### Minitest vs RSpec

Minitest is part of the Ruby standard library, while RSpec is not. Minitest is a bundled gem, meaning it is installed with the Ruby installation as the default Ruby testing library, though it can be uninstalled if necessary. RSpec is a normal gem that must be deliberately installed by the user.

In terms of basic functionality, Minitest can do anything RSpec can do. However, Minitest has a straightforward default syntax that is largely just Ruby code. RSpec is a Domain Specific Language designed to allow us to write tests that read much like English.

While Minitest can optionally use a DSL, the standard Minitest syntax is for the most part standard Ruby syntax. This can make writing and understanding Minitest tests simpler than in RSpec, especially for beginners.

Minitest's standard syntax is assert-style (or assertion-style) syntax. Minitest's optional DSL allows us to write spec-style (or expectation-style) syntax, which is similar to RSpec's syntax. Spec-style syntax might read more like English natural language, but it requires learning more new (and somewhat opaque) syntax to achieve this.

Minitest is not as flexible or powerful as RSpec but it does have all the functionality necessary for most testing scenarios.



### SEAT Approach

The SEAT approach breaks down writing a test into four steps:

1. Set up the necessary objects
2. Execute the code against the object we're testing
3. Assert that the executed code did the right thing
4. Tear down and clean up any lingering artifacts



1) Setup step.

We generally need to instantiate objects before each test we run. This can be repetitious. For instance, if we have many of tests all of which test whether a class is functioning correctly, we might need to instantiate an object of that class before every individual test. In Minitest, we can extract this common set up step to the `#setup` method of our test class. The `#setup` method will be called before every test method in that class is executed.

2. Execute step.

We generally need to execute some code against the object we are testing in order to receive an expected return value, or to change the state of the object or achieve some other expected side effect.

3. Assert step.

This is the actual test step. Minitest has a range of assertions to deal with different expected outcomes.

4. Teardown step.

We often need to clean up lingering artifacts such as open file or database handles, freeing the resources that we have acquired, usually during the Setup step. In Minitest, we can write a `#teardown` method for our test class that is automatically called after each test method is run.



Every test will require at least Execute and Assert steps. In Minitest, the `#setup` and `#teardown` methods are both optional, and each can be defined without the other. The `#setup` method is called automatically before each test in the class, and commonly instantiates objects and sets instance variables to them to be used in the tests. The `#teardown` method is automatically called after each test in the class. Use of these methods for common Setup and Teardown actions reduces repetition in our code.



### Testing Equality

The `assert_equal` assertion is one of the most commonly used assertions. The kind of equality asserted by `assert_equal(expected, actual)` is value equality, or equivalence of states. The method it uses to compare the `expected` object with the `actual` object is the `==` method, which returns `true` if the caller and argument have an equivalent representative object value, `false` otherwise. `assert_equal` fails unless `expected == actual`. This means that an appropriate `==` method must be defined for the objects being asserted against.

The other form of equality we may wish to assert is object equality. For this we use the `assert_same` assertion. When we use `assert_same(expected, actual)`, we are testing whether the object referenced by `expected` is the same object with the same object id as the object referenced by `actual`; `assert_same` will fail unless this is the case. We can think of `assert_same` as using the `BasicObject#equal?` method.

So `assert_equal` checks for value equality between two (potentially) different object, and `assert_same` checks for object equality between two variables (or other forms of object reference).



### Assertions

An assertion is an actual test step, the verification step that confirms the actual data returned or output by our code is the data we expect. We can make one or more assertions within a test case. If the data returned by our program matches the expected data, the assertion passes; otherwise, the assertion fails.

Refutations are the logical opposite of assertions. A refutation seeks to deny that the actual data returned by our code matches some proscribed data. A refutation fails if the data matches; otherwise, the refutation passes.

Assertions are vastly more common than refutations, though sometimes the logic of a refutation is more readily comprehensible. Most assertion methods have a corresponding refutation. The refutation form of an assertion takes the same positional arguments and blocks as the assertion, but with the logic of passing or failure inverted.

