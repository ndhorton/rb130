

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



7. What will line 9 return and why?

```ruby
def call_me(some_code)
  some_code.call
end


chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Robert"

call_me(chunk_of_code)
```



8. Will this code produce an error? Why, or why not?

```ruby
my_proc = Proc.new { puts d }

def d
  4
end

my_proc.call
```



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

