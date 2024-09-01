# closures

def sequence
  counter = 0
  Proc.new { counter += 1 }
end

s1 = sequence
p s1.call
p s1.call
p s1.call
puts

s2 = sequence
p s2.call
p s1.call  # note: this is s1
p s2.call
