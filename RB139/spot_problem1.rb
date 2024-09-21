# Problem
def call_this
	yield(2)
end

to_s = proc { |num| num.to_i }
to_i = proc { |num| num.to_s }

# How to get the following return values with[out?] modifying the method invocation nor the method definition
p call_this(&to_s) # => returns 2
p call_this(&to_i) # => returns "2"
