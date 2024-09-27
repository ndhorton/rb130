# 2. Robot Name

=begin

P:

* Write a program that manages a Robot's factory settings.
- The factory settings consist of a randomly chosen name.
- The random name should consist of two random uppercase letters and three
    random digits
- There should be an internal mechanism (across Robots) to prevent the same name
    being used twice for different Robots.

Etc:

name regexp /^[A-Z]{2}\d{3}$/
two random uppercase letters plus three random digits

We need to keep generating random names and checking them against
a class-level array accessed with

DS:



class Robot
needs some kind of class (instance?) variable and class methods
  such that we can keep a class-internal array of previous robot names
  and prevent the same name being used twice
#initialize(should initialize name with random name)
#name attribute (should hang on to name, no randomness here)
#reset (reset name)

A:

=end

# class Robot
#   DIGITS = ('0'..'9').to_a.freeze
#   LETTERS = ('A'..'Z').to_a.freeze
#   private_constant :DIGITS, :LETTERS

#   @@used_names = []

#   attr_reader :name

#   def initialize
#     @name = nil
#     restore_factory_settings
#   end

#   def reset
#     @@used_names.delete(@name)  # added this after seeing LS Algorithm section
#     restore_factory_settings
#   end

#   private

#   def restore_factory_settings
#     name = nil
#     loop do
#       name = random_name
#       break unless @@used_names.include?(name)
#     end
#     @@used_names << name
#     @name = name
#   end

#   def random_name
#     random_letters(2) + random_digits(3)
#   end

#   def random_digits(num)
#     digits = ''
#     num.times { digits << DIGITS.sample }
#     digits
#   end  

#   def random_letters(num)
#     letters = ''
#     num.times { letters << LETTERS.sample }
#     letters
#   end
# end

# 31:52

# LS solution
class Robot
  @@names = []

  def name
    return @name if @name
    @name = generate_name while @@names.include?(@name) || @name.nil?
    @@names << @name
    @name
  end

  def reset
    @@names.delete(@name)
    @name = nil
  end

  private

  def generate_name
    name = ''
    2.times { name << rand(65..90).chr }
    3.times { name << rand(0..9).to_s }
    name
  end
end
