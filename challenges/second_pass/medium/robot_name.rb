# Robot Name

=begin

P:

Write a program that manages randomly generated robot names.

Names must be two uppercase letters followed by three digits
Robot must remember previous names so that if the robot is
reset and a new name is automatically generated, even if we
contrive the seeding so that the same name is generated twice,
the robot will generate a new one that it hasn't had before.

Etc:

DS:

A:

#initialize
Set @names := [ generate_name() ]

#name
@names.last

#generate_name
Set characters := empty array
Iterate twice
  push generate_char() to characters
Iterate three times
  push generate_digit to characters
Join characters to string
return string

#reset
Set new_name := generate_name()
Repeat until new_name is not included in @names
Push generate_name() to @names

This doesn't work. It wants this to be managed at the class level
such that two new Robots cannot have the same name.

#generate_digit
randomly generate integer between 0 and 9
convert to string and return

#generate_char
randomly generate integer between 0 and 25
add 65 and convert to string
return string

=end

class Robot
  attr_reader :name

  @@names = []

  def initialize
    @name = generate_name
  end

  def reset
    @@names.delete(@name) # added after reading LS solution
    @name = generate_name
  end

  private

  def generate_name
    new_name = build_name
    while @@names.include?(new_name)
      new_name = build_name
    end
    @@names << new_name
    new_name
  end

  def build_name
    characters = []
    2.times { characters << generate_letter }
    3.times { characters << generate_digit }
    characters.join
  end

  def generate_letter
    rand(65..90).chr
  end

  def generate_digit
    rand(9)
  end
end

# 28:54

# 31:24 passes rubocop

# LS solution suggests that we need to delete a name
# from the @@names array when a robot is reset.
# There's no way to infer this from the tests and I don't
# think "their name gets wiped" suggests this at all in its
# context. Weird.
