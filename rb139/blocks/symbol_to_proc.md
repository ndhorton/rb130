`&:symbol`

An implicit block argument to a method can only be used during the method call. If we wanted to pass the block on to another method, we need an explicit block parameter, which converts the block to a Proc object.

In a method definition, an `&` prefixed to a parameter in the parameter list denotes an explicit block argument; Ruby converts the implicit block to a Proc object and assigns it to the `&`-prefixed parameter. We now have an explicit parameter that references the Proc version of the block passed to the method. It can be passed around to other methods, returned, and generally treated like any other object.

On the other end at invocation time, unary `&` prefixed to a Proc object in the argument list of a method invocation converts the Proc object to a block to be passed as an implicit block argument to the method call. Unary `&` used in this way implcitly calls `#to_proc` on the argument before attempting conversion. If the object is a Proc, `Proc#to_proc` simply returns the caller, and the Proc is converted to a block. If the object is a symbol, `Symbol#to_proc` will be called. If the object does not have a `to_proc` method, a `TypeError` will be raised.

`Symbol#to_proc` is designed to assume that the Symbol it is called on is the name of a method. So if, for instance, `to_proc` is called on the symbol `:to_s`, it will return a Proc whose code would be equivalent to:

```ruby
{ |obj| obj.to_s }
```

The unary `&` operator then converts this Proc object to a block to be implicitly passed to the method call.

Material

1:15: Symbol to proc



"If you look closely, somehow this code:

```ruby
(&:to_s)
```

... gets converted to this code:

```ruby
{ |element| element.to_s }
```

What's the mechanism at work here?"

"Although it's [conceptually] related to the use of `&` with explicit blocks, this is something else because we're not working with explicit blocks here. (Explicit blocks can be identified by looking out for an `&` in the paramter list for a method)"



"Instead, we're applying the `&` operator to an object (possibly referenced by a variable), and when this happens, Ruby tries to convert the object to a block. That's easy if the object is a Proc-vonerting a Proc to a block is something that Ruby can do naturally. However, if the object is not already a Proc, we have to first convert it to a Proc. In that case, we call `#to_proc` on the object, which returns a Proc. Ruby can then convert the resulting Proc to a block"

* `&:to_s` tells Ruby to convert the Symbol `:to_s` to a block
* Since `:to_s` is not a Proc, Ruby first calls `Symbol#to_proc` to convert the symbol to a Proc
* Not it is a Proc, Ruby then converts this Proc to a block

Code Examples

This example demonstrates a `map` call that uses a block argument to transform every element in an array using the `Integer#to_s` method, and then another call to `map` that uses `&:symbol` syntax to do the same thing:

```ruby
[1, 2, 3, 4, 5].map do |num|
  num.to_s
end
# => ["1", "2", "3", "4", "5"]

[1, 2, 3, 4, 5].map(&:to_s)                     # => ["1", "2", "3", "4", "5"]
```

This example demonstrates chaining iterator method calls that use `&:symbol` syntax:

```ruby
[1, 2, 3, 4, 5].map(&:to_s).map(&:to_i)         # => [1, 2, 3, 4, 5]
```

This example demonstrates a selection of iterator calls using `&:symbol` syntax:

```ruby
["hello", "world"].each(&:upcase!)              # => ["HELLO", "WORLD"]
[1, 2, 3, 4, 5].select(&:odd?)                  # => [1, 3, 5]
[1, 2, 3, 4, 5].select(&:odd?).any?(&:even?)    # => false
```

This example demonstrates use of `&` to convert a Symbol to a Proc and then the Proc to a block:

```ruby
def my_method
  yield(2)
end

# turns the symbol into a Proc, then & turns the Proc into a block
my_method(&:to_s)               # => "2"
```

This example demonstrates converting a Symbol to a Proc and then using the `&` operator on the variable that references the Proc:

```ruby
def my_method
  yield(2)
end

a_proc = :to_s.to_proc          # explicitly call to_proc on the symbol
my_method(&a_proc)              # convert Proc into block, then pass block in. Returns "2"
```

