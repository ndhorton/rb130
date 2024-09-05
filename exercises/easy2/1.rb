# From-To-Step Sequence Generator

def step(start, finish, difference)
  counter = start
  while counter <= finish
    yield(counter)
    counter += difference
  end
end

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

step(1, 10, 3) { |value| puts "value = #{value}" }
