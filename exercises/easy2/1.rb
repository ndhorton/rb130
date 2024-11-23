# From-To-Step Sequence Generator

def step(start, finish, difference)
  counter = start
  while counter <= finish
    yield(counter)
    counter += difference
  end
  start
end

# My thinking for the return value is that this method
# actually resembles Integer#step more than Range#step
# and since Integer#step returns the caller, the starting number,
# I decided to return the first argument, the starting number,
# imitating the conventions of Ruby's core classes.

# LS solution
def step(start_point, end_point, increment)
  current_value = start_point
  loop do
    yield(current_value)
    break if current_value + increment > end_point
    current_value += increment
  end
  current_value
end

p step(1, 10, 3) { |value| puts "value = #{value}" }
