def a_method
  yield
end

p a_method { "I'm a block in Example 1" }