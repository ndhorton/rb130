def fields(text)
  text.split(/[ \t,]+/)
end

p fields("Pete,201,Student")     # ["Pete", "201", "Student"]
p fields("Pete \t 201   ,  TA")  # ["Pete", "201", "TA"]
p fields("Pete \t 201")          # ["Pete", "201"]
p fields("Pete \n 201")          # ["Pete", "\n", "201"]