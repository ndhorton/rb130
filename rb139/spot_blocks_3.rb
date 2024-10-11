def a_method(&expecting_a_block)
  expecting_a_block.call
end

b_proc = proc { "I'm a block" }

p a_method(&b_proc)
