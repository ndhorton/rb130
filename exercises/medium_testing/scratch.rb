begin
  file = File.open("#{__dir__}/lorem_ipsum.txt", "r")
  text = file.read
  text = text.gsub('a', 'e')
  puts text
ensure
  puts "tearing down..."
  file.close
end