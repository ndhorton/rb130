def call_me(some_code)
  some_code.call  # call will execute the "chunk of code" passed in
end

name = "Robert"
chunk_of_code = Proc.new { puts "hi #{name}" }
name = "Griffin III" # re-assign name after Proc initialization

call_me(chunk_of_code)
