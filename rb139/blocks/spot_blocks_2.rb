def a_method(&expecting_a_block)
  expecting_a_block.call
end

p a_method { "I'm a block in Example 2" }

p a_method