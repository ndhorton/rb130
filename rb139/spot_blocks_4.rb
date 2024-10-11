def c_method(expecting_a_proc)
  expecting_a_proc.call
end

c_proc = proc { "I'm a proc" }
p c_method(c_proc)