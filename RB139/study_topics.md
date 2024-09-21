- Blocks
  - Closures, binding, and scope -- Definition of a closure ('chunk of code' that can be passed around and executed later that has an environment, etc), the scope of its bindings, the way it captures local variables defined in scope *above/before* the closure definition, and methods on the closure's `self` that are defined *before the closure is **executed***
  - How blocks work, and when we want to use them -- deferring method logic to invocation, sandwich code methods
  - Blocks and variable scope -- local variables in scope initialized before/above the definition, constants in lexical scope when closure is defined
  - Create custom methods that use blocks and procs -practice doing this
  - Understand that methods and blocks can return chunks of code (closures) - practice doing this
  - Methods with an explicit block parameter - `&block` practice doing this
  - Arguments and return values with blocks - 
  - When you can pass a block to a method - always, though only used if `yield` used
  - `&:symbol` - `Symbol#to_proc`, proc-to-block conversion, also be familiar with `&variable` where variable references a proc, so here `&` only needs to do proc-to-block conversion. Basically, when used in a method invocation argument list, `&` will call `to_proc` on the argument if it is not already a Proc (and possibly even if it is, since `Proc#to_proc` is "part of the protocol for converting objects to `Proc` objects" , and then convert the proc to a block
  - Arity of blocks and methods
- Testing
  - Testing terminology
  - Minitest vs. RSpec
  - SEAT approach
  - Testing equality
  - Assertions
- Packaging Code into a Project
  - Purpose of core tools - descriptions of Rake, Rubygems, Ruby version managers, Bundler, `Gemfile`, `Gemfile.lock`, `Rakefile`, `.ruby-version`, basic directory structure for Gem format
  - `Gemfile`