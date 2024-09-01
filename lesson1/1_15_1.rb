result = [1, 2, 3, 4, 5].map do |num|
  num.to_s
end

p result

result = [1, 2, 3, 4, 5].map(&:to_s)

p result

p ["hello", "world"].each(&:upcase!)
p [1, 2, 3, 4, 5].select(&:odd?)
p [1, 2, 3, 4, 5].select(&:odd?).any?(&:even?)

