Methods with an explicit block parameter



Material

1:4: Writing methods that take blocks



Passing a block to a method explicitly.

Implicit block passing (block is defined on method invocation, passed implicitly, and called using `yield` keyword)

"Until now we've passed blocks to methods implicitly. Every method, regardless of its definition, takes an implicit block. It may ignore the implicit block, but it still accepts it."

"However, there are times when you want a method to take an explicit block; an explicit block is a block that gets treated as a named object -- that is, it gets assigned to a method parameter so that it can be managed like any other object -- it can be reassigned , passed to other methods, and invoked many times. To define an explicit block, you simply add a  parameter to the method definition where the name begins with a `&` character"

"As you can see, the `block` local variable is now a Proc object. Note that we can name it whatever we please; it doesn't have to be `block`, just as long as we define it with a leading `&`"

"Why do we... need an explicit block? Chiefly the answer is that it provides additional flexibility. Before, we didn't have a handle (a variable) for the implicit block, so we couldn't do much with it except yield to it and test whether a block was provided. Now we have a variable that represents the block, so we can *pass the block to another method*"



Code examples

This example demonstrates that when we pass an explicit block using `&parameter` syntax, Ruby converts the block to a Proc object:

```ruby
def test(&block)
  puts "What's &block? #{block}"
end

test { sleep 1 }

# What's &block? #<Proc:0x007f98e32b83c8@(irb):59>
# => nil
```

This example demonstrates passing an explicit block (converted to Proc object) to another method:

```ruby
def test2(block)
  puts "hello"
  block.call          # calls the block that was originally passed to test()
  puts "good-bye"
end

def test(&block)
  puts "1"
  test2(block)
  puts "2"
end

test { |prefix| puts "xyz" }
# => 1
# hello
# xyz
# good-bye
# => 2
```

Note that you only need to use `&` for the `block` parameter in `#test`. Since `block` is already a Proc object when we call `test2`, no conversion is necessary.



This example demonstrates passing arguments to the explicit block by using them as arguments to `Proc#call`:

```ruby
def display(block)
  block.call(">>>") # Passing the prefix argument to the block
end

def test(&block)
  puts "1"
  display(block)
  puts "2"
end

test { |prefix| puts prefix + "xyz" }
# => 1
# >>>xyz
# => 2
```

