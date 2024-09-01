level_1 = "outer-most variable"

[1, 2, 3].each do |n|           # block creates a new scope
  level_2 = "inner variable"

  ['a', 'b', 'c'].each do |n2|  # nested block creates a nested scope
    level_3 = "inner-most variable"

    # all three level_X variables are accessible here
  end

  # level_1 is accessible here
  # level_2 is accessible here
  # level_3 is not accessible here

end

# level_1 is accessible here
# level_2 is not accessible here
# level_3 is not accessible here

