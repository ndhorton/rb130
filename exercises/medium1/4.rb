# Passing Parameters Part 2

=begin

P:

Etc:

DS:

A:

=end

def splat_yielder(array)
  yield(*array)           # The splat here is unnecessary, see below
end

def params(_, _, *raptors)
  p raptors
end

def lambda_params(birds, lamb)
  lamb.call(*birds)  # The splat is necessary because lambdas have strict arity
end

def proc_params(birds, pr)
  pr.call(birds)  # Splat unnecessary because ordinary procs have lenient arity
end

# LS solution
def types(birds)
  yield birds  # No splat needed because block params have lenient arity
end

birds = %w(raven finch hawk eagle)

# lamb = ->(_, _, *raptors) { p raptors }
# pr = Proc.new { |_, _, *raptors| p raptors }

# lambda_params(birds, lamb)
# proc_params(birds, pr)

# params(*birds) # splat is necessary because method params have strict arity

types(birds) do |_, _, *raptors|
  puts "Raptors: #{raptors.join(', ') }."
end

# p (_, _, *raptors = *birds) == (_, _, *raptors = birds) 
# splat unnecessary because multiple assignment has lenient arity

