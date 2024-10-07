def foo
  return Proc.new { 5 } 
end

p foo.source_location