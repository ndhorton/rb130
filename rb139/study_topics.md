- Blocks
  - Closures, binding, and scope -- 
  
    Definition of a closure. A closure is a block of code with an environment that can be passed around as an object and executed later.
  
    In Ruby, the environment of a closure is called its binding, and a binding is an object of the Binding class.
  
    The scope of a closure.
  
    For blocks, only definitions and initializations that come before the block definition are accessible in the block. This is because the block will be executed immediately by the method invocation on which the block is defined and Ruby will not have a chance to look at any variable initializations or method definitions that occur after the block definition.
  
    
  
    For Proc objects (including lambdas), the situation is more complicated. Local variables must be initialized before the Proc object is defined for the Proc to be able to reference them. However, constants and methods can be referenced successfully within a Proc even if they are defined after the Proc definition just so long as the definitions occur before the Proc is actually
  
    executed.
  
    
  
    The Binding object of the Proc will capture all local variables in the lexical scope, even those local variables initialized after the Proc definition (and even if they are not referenced in the Proc code block itself). However, the Proc code block itself only has access to those local variables defined before its own definition. The reasons for the binding capturing all local variables have to do with the details of the Ruby implementation and the facilities Ruby possesses for metaprogramming. These are well beyond the scope of this course.
  
    
  
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

