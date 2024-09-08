fibonacci = Enumerator.new do |yielder|
  a = 0
  b = 1
  yielder << a
  yielder << b
  loop do
    a, b = b, a + b
    yielder << b
  end
end

def each_with_index(ext_iterator)
  ext_iterator.rewind
  index = 0
  begin
    while true
      yield(ext_iterator.next, index)
      index += 1
    end
  rescue StopIteration
  end
end

each_with_index(fibonacci) do |fib, index|
  puts "fibonacci_#{index} == #{fib}"
  break if fib > 100
end