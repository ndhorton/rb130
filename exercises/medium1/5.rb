# Passing Parameters Part 3

items = ['apples', 'corn', 'cabbage', 'wheat']

# def gather(items)
#   puts "Let's start gathering food."
#   yield(items)
#   puts "We've finished gathering!"
# end

# # 1)
# gather(items) do |*others, wheat|
#   puts others.join(', ')
#   puts wheat
# end

# # 2)
# gather(items) do |apples, *others, wheat|
#   puts apples
#   puts others.join(', ')
#   puts wheat
# end

# # 3)
# gather(items) do |apples, *others|
#   puts apples
#   puts others.join(', ')
# end

# # 4)
# gather(items) do |apples, corn, cabbage, wheat|
#   puts "#{apples}, #{corn}, #{cabbage}, and #{wheat}"
# end

# 1)
def gather(*produce, wheat)
  puts "Let's start gathering food."
  puts produce.join(', ')
  puts wheat
  puts "We've finished gathering"
end

# 2)
def gather(apples, *vegetables, wheat)
  puts "Let's start gathering food."
  puts apples
  puts vegetables.join(', ')
  puts wheat
  puts "We've finished gathering!"
end

# 3)
def gather(apples, *assorted)
  puts "Let's start gathering food."
  puts apples
  puts assorted.join(', ')
end

# 4)
def gather(apples, corn, cabbage, wheat)
  puts "Let's start gathering food."
  puts "#{apples}, #{corn}, #{cabbage}, and #{wheat}"
  puts "We've finished gathering!"
end

# Notice we need a splat operator for passing in the array now
# we are passing to method's parameters instead of block's
gather(*items)

# Essentially, lenient arity in Ruby let's you pass an array as an argument
# and have it be treated either as an array or as a list of discrete arguments,
# depending on the block parameters, much like with multiple assignement

# Strict arity means that we cannot do this and must take care 
# whether we need to splat open an array when passing to a method or lambda 
# in order to assign its elements to the positional parameters