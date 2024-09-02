def compute
  if block_given?
    yield
  else
    "Does not compute."
  end
end

# LS solution
def compute
  return "Does not compute." unless block_given?
  yield
end

# further exploration
def compute(obj)
  return 'Does not compute.' unless block_given?
  yield(obj)
end

# p compute { 5 + 3 } == 8
# p compute { 'a' + 'b' } == 'ab'
# p compute == 'Does not compute.'

p compute(3) == 'Does not compute.'
p compute(3) { |num| num * num } == 9
p compute('world') { |text| 'hello ' + text }