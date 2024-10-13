Blocks and Variable Scope

I don't know exactly how this topic differs from 'Closures, binding, and scope'. Obviously, if you get a question involving blocks, probably say, "This code is an example of how Ruby treats variable scope with respect to blocks", and if you get a question on a Proc, say "This code is an example of local variable scope with respect to closures and their binding" or something like that.

Material

1:14: Blocks and Variable Scope

"A Refresher... Recall that previously we asked you to memorize local variable scope in terms of *inner* and *outer* scope, as determined by where the local variable was initialized. A block creates a new scope for local variables, and only outer local variables are accessible to inner blocks [and not vice versa]."

"Remember that this is only for *local variables*... If it's a method, it doesn't follow this rule."

"A Proc keeps track of its surrounding context, and drags it around wherever the chunk of code is passed to. In Ruby, we call this its **binding**, or surrounding environment/context. A closure must keep track of its binding to have all the information it needs to be executed later."

"This [binding] not only includes local variables, but also method references, constants and other artifacts in your code -- whatever it needs to execute correctly, it will drag all of it around. It's why code like the above works fine, seemingly violating the variable scoping rules we learned earlier."

"Note that any local variables that need to be accessed by a closure must be defined *before* the closure is created [in order for the closure to bind/capture them]"

"Bindings and closures are at the core of variable scoping rules in Ruby. It's why 'inner scopes can access outer scopes'. It'll be hard to remember the details of bindings and closures as you code, so it may still be useful to remember the rule, but, the point of this... is to show that how Ruby implements closures is at the core of how variable scope works. Therefore it's at the core of how Ruby itself works."



Code Examples

This example demonstrates the simplified mental model of blocks and local variable scope we learned in RB101-120:

```ruby
level_1 = "outer-most variable"

[1, 2, 3].each do |n|                     # block creates a new scope
  level_2 = "inner variable"

  ['a', 'b', 'c'].each do |n2|            # nested block creates a nested scope
    level_3 = "inner-most variable"

    # all three level_X variables are accessible here
  end

  # level_1 is accessible here
  # level_2 is accessible here
  # level_3 is not accessible here

end

# level_1 is accessible here
# level_2 is not accessible here
# level_3 is not accessible here
```



This example demonstrates that a local variable initialized in the scope where a closure is defined can be referenced by the "code chunk" of the closure even when it is called from the different, self-contained scope for local variables of a method the closure object is passed to as argument:

```ruby
def call_me(some_code)
  some_code.call    # call will execute the "chunk of code" that gets passed in
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}

call_me(chunk_of_code)
```

This example demonstrates that a closure binds to the local variable in its outer scope, it doesn't just make a copy, since we can reassign the variable after the closure is created and the closure binding will register the reassignment:

```ruby
def call_me(some_code)
  some_code.call
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"        # re-assign name after Proc initialization

call_me(chunk_of_code)
```

This example demonstrates that closures only capture/bind to local variables initialized before they are created, not after:

```ruby
def call_me(some_code)
  some_code.call
end


chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"

call_me(chunk_of_code) # raises NameError
```

