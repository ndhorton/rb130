=begin
So a URL for this method:
https?://(some chars .) could be more than 1 some chars
can't have leading or trailing spaces or chars
=end

def url?(text)
  text.match?(/\Ahttps?:\/\/(\S+?\.){1,}\S+\z/i)
end

p url?('https://launchschool.com')     # -> true
p url?('http://example.com')           # -> true
p url?('https://example.com hello')    # -> false
p url?('   https://example.com')       # -> false
p url?('https://foo.bar.com/index.html') # -> true