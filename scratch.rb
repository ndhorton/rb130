def test(&block)
  puts "What's &block? #{block}"
end

test { sleep 1 }