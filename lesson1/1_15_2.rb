def my_method
  yield(2)
end

# turns the symbol into a Proc, then & turns the Proc into a Symbol
p my_method(&:to_s)

a_proc = :to_s.to_proc  # explicitly call to_proc on the Symbol
p my_method(&a_proc)    # convert Proc into block, then pass block in