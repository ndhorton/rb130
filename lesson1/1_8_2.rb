# build a `reduce` method

=begin

The problem is that we must know whether a second argument is passed.
If we use Ruby's default argument syntax

def reduce(array, memo = array.first)
  # ...
end

Then we don't know which element of the array to take as our second block
argument on the first iteration. If we have been given a second argument,
then we should start iterating at the first element of the array, otherwise
the second element of the array.

=end

# The problem with Launch School's implementation is that the `default`
# default value only takes account of Numerics. If our array is an array
# of Strings, we will likely raise an error on the first block iteration.

def reduce(array, default = 0)
  counter = 0
  accumulator = default

  while counter < array.size
    accumulator = yield(accumulator, array[counter])
    counter += 1
  end

  accumulator
end

# solution with default value argument, maybe too compressed, from StackOverflow
def reduce(array, default = (arg2_not_passed = true; array[0]))
  counter = (arg2_not_passed ? 1 : 0)
  memo = default

  while counter < array.size
    memo = yield(memo, array[counter])
    counter += 1
  end

  memo
end

# my initial method implementation
def reduce(*args)
  unless (1..2).cover?(args.size) && block_given?
    raise ArgumentError,"wrong number of arguments (given " \
      "#{args.size + (block_given? ? 1 : 0)}, expected 2..3)"
  end
  
  array = args.first
  memo = (args.size == 1 ? array[0] : args[1])
  counter = (args.size == 1 ? 1 : 0)

  while counter < array.size
    memo = yield(memo, array[counter])
    counter += 1
  end

  memo
end

# less compressed default argument version, Edmond Tam in the Forum
def reduce(array, starting_total = omitted = true)
  total = (omitted ? array[0] : starting_total)
  counter = (omitted ? 1 : 0)

  while counter < array.size
    total = yield(total, array[counter])
    counter += 1
  end

  total
end

array = [1, 2, 3, 4, 5]

p reduce(array) { |acc, num| acc + num }                    # => 15
p reduce(array, 10) { |acc, num| acc + num }                # => 25
# reduce(array) { |acc, num| acc + num if num.odd? }        # => NoMethodError: undefined method `+' for nil:NilClass

p reduce(['a', 'b', 'c']) { |acc, value| acc += value }     # => 'abc'
p reduce([[1, 2], ['a', 'b']]) { |acc, value| acc + value } # => [1, 2, 'a', 'b']