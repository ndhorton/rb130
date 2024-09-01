# life without blocks

def compare(str, flag)
  after = case flag
          when :upcase
            str.upcase
          when :capitalize
            str.capitalize
            # etc, we could have a lot of 'when' clauses
          end
          
  puts "Before: #{str}"
  puts "After: #{after}"
end

compare("hello", :upcase)