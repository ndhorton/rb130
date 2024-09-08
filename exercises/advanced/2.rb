# Exploring Procs, Lambdas, and Blocks: Definition and Arity

# Group 1
# my_proc = proc { |thing| puts "This is a #{thing}." }
# puts my_proc
# puts my_proc.class
# my_proc.call
# my_proc.call('cat')

# We can call our proc without an argument and the parameter is assigned nil

# Group 2
# my_lambda = lambda { |thing| puts "This is a #{thing}." }
# my_second_lambda = -> (thing) { puts "This is a #{thing}." }
# puts my_lambda
# puts my_second_lambda
# puts my_lambda.class
# my_lambda.call('dog')
# my_lambda.call
# my_third_lambda = Lambda.new { |thing| puts "This is a #{thing}." }

# So a lambda is also an instance of Proc class
# The to_s method includes the fact that it is a lambda (though class is still
# Proc)
# Cannot call the lamda without right number of args
# The stacktrace for the ArgumentError shows as 'block in main'
# We cannot call `Lambda.new` because there is no special `Lambda` class
# (unless its under the namespace of Proc or something)

# Group 3
# def block_method_1(animal)
#   yield
# end

# block_method_1('seal') { |seal| puts "This is a #{seal}."}
# block_method_1('seal')

# We do not need to pass the right number of arguments when we yield
# to an implicit block
# We need to pass an implicit block to a method if that method uses yield
# without checking if a block has been passed (LocalJumpError)

# Group 4
# def block_method_2(animal)
#   yield(animal)
# end

# block_method_2('turtle') { |turtle| puts "This is a #{turtle}."}
# block_method_2('turtle') do |turtle, seal|
#   puts "This is a #{turtle} and a #{seal}."
# end
# block_method_2('turtle') { puts "This is a #{animal}." }

# We do not need to pass the right number of arguments to an implicit block
# If we pass too few, the block parameters that do not have an argument will
# be assigned nil
# Not sure what they're getting at with the last line, `animal` needs to be
# initialized, either as a block parameter or just a block local variable
# within the body of the block, before we can reference it

# Blocks and regular Proc objects have lenient arity. If we pass arguments
# when there are no parameters to recieve them, the extra arguments are ignored.
# If we pass too few arguments, the extra parameters will be assigned nil.
# Proc is a class and a simple proc is an instance of that class.

# A lambda has strict arity. We must pass an object as argument to each of a
# lamda's parameters. A lambda is not an instance of class Lambda, but an instance
# of class Proc. Nevertheless there are differences between a lambda and a proc,
# arity being one. Calling `to_s` on a lambda shows that it is a Proc object, but
# includes `(lambda)` after the other information to denote that is a lambda type
# of proc.

# We define a block as part of a method invocation
# We define a Proc using Proc.new or the Kernel#proc method
# We define a lambda using the Kernel#lambda method or the -> operator
