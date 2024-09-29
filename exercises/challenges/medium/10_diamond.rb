# 1. Diamond

=begin

P:

Write a program that draws an ascii diamond using alphabet
uppercase chars.

The first row will always be a single A
Each row thereafter consists of the next letter in the alphabet
The grid size will always be odd
The letter given as input will determine grid size
Letters range from 'A' through 'Z'
Grids range from 1(1 * 2 - 1) through 51 (26 * 2 - 1)
Grid must contain grid_size letters and spaces per row,
  meaning the right side must be padded with spaces before newline

Etc:

If the diamond is given 'A', this results in a degenerate diamond
consisting of a single 'A'

A - 1st letter - grid size 1
B - 2nd - 3
C - 3rd - 5

"B" gives you

 A
B B
 A

C gives you

  A
 B B
C   C
 B B
  A

A - 1 at widest point (grid size 1)
B - 3 grid
C - 5
D - 7

So we need a method that maps alphabet char -> number representing grid size
ordinal * 2 - 1

grid size = 5

  *
 * *
*   *
 * *
  *

1st and last line: 0 spaces in between
increases to 1, then by 2, so always odd
middle line: grid_size - 2 spaces in between

padding left right:
grid size 5 / 2 = 2

the first line will be grid_size / 2 spaces either side the A

So halve the grid_size intdiv and count down to zero

first row: (' ' * (grid_size / 2)) + 'A' + (' ' * (grid_size / 2))
second row: (' ' * (grid_size / 2 - 1)) + 'A'.next

So what we actually need to track is the space between letters
We need a special case for first/last line where only one letter
Use center padding to manage spaces on either side

So something like
letter.center(grid_size) + "\n" # line 1
letter = letter.next
letter + (' ' * (index+1)*2-1)

DS:
input: alphabetic character string
output: return a string representation of the diamond

Hash for mapping input letter to grid size:
zip (A..Z) with (1..51 step 2) and convert to hash

An approach might be to generate array of arrays with ' '
[
  [' ', '*', ' '],
  ['*', ' ', '*'],
  [' ', '*', ' ']
]

So by this approach, we draw the first and last line
  with one 'A' at index grid_size / 2 + 1
Then, the index for the left letter is grid_size / 2 - 1, decrement each time
Then, 1 up to grid_size / 2 - 1

The index for the right letter is grid_size / 2 + 2, increment each time
Then, 1 down to grid_size / 2 + 2

Another approach is to draw the left side and mirror it, or draw the first half
  and mirror it
This would only work well with the array approach, since we need to mirror
  half lines/whole lines

  [' ', ' ', 'A', ' ', ' '],
  [' ', 'B', ' ', 'B', ' '],

  ['C', ' ', ' ', ' ', 'C']
  ,
  [' ', 'B', ' ', 'B', ' '],
  [' ', ' ', 'A', ' ', ' ']

A:

#make_diamond
Given an uppercase letter, control_letter
Set grid_size := map control_letter through GRID_SIZES
generate terminal line
1 to grid_size - 2, i, letter + (' ' * i) + letter all centered in grid size
same for grid_size - 4 to 1 except we need a way to go back for letters
generate terminal line

#make_diamond (array version)
Given an uppercase letter, control_letter
Return 'A' if control_letter is 'A'
Set grid_size := map control_letter through GRID_SIZES
Set top := draw_top
Set bottom := reverse top
Set middle_line := draw_middle_line
Return top + middle_line + bottom

#draw_top
Given an integer, grid_size
Set letter := 'A'
Set diamond := new array
Set middle_index := grid_size / 2
Iterate for offset from 0 to grid_size / 2 - 1 inclusive
  Set row := new array of space chars, size grid_size
  row[middle_index - offset] = letter
  row[middle_index + offset] = letter
  letter = next letter
Return diamond

#draw_middle_line
Given a string, control_letter
Set grid_size := map control_letter through GRID_SIZES
Set row := array of one empty array
row[0][0] = control_letter
row[0][-1] = control_letter
return row

=end

class Diamond
  GRID_SIZES = ('A'..'Z').zip(1.step(51, 2)).to_h.freeze

  def self.make_diamond(control_letter)
    grid_size = GRID_SIZES[control_letter]

    diamond = generate_terminal_line(grid_size)
    diamond = draw_top_half(diamond, grid_size)
    diamond = draw_bottom_half(diamond, grid_size)
    diamond << generate_terminal_line(grid_size) if grid_size > 1
    diamond
  end

  class << self
    private

    def draw_top_half(diamond, grid_size)
      letter = 'A'
      1.step(grid_size - 2, 2) do |spaces|
        letter = letter.next
        diamond += "#{(letter + (' ' * spaces) + letter).center(grid_size)}\n"
      end
      diamond
    end

    def draw_bottom_half(diamond, grid_size)
      letter = GRID_SIZES.key(grid_size)
      1.step(grid_size - 4, 2).reverse_each do |spaces|
        letter = (letter.ord - 1).chr
        diamond += "#{(letter + (' ' * spaces) + letter).center(grid_size)}\n"
      end
      diamond
    end

    def generate_terminal_line(grid_size)
      "#{'A'.center(grid_size)}\n"
    end
  end
end

# 58:59

# Second attempt with Array strategy
# class Diamond
#   GRID_SIZES = ('A'..'Z').zip(1.step(51, 2)).to_h.freeze

#   def self.make_diamond(control_letter)
#     return "A\n" if control_letter == 'A'  # degenerate case of diamond

#     grid_size = GRID_SIZES[control_letter]
#     top = draw_top(grid_size)
#     middle_line = draw_middle_line(control_letter)
#     bottom = top.reverse
#     join_sections(top, middle_line, bottom)
#   end

#   class << self
#     private

#     def join_sections(top, middle, bottom)
#       top = top.map { |row| row.join }
#       middle_string = middle.join + "\n"
#       bottom = bottom.map { |row| row.join }
#       top.join("\n") + "\n" + middle_string + bottom.join("\n") + "\n"
#     end

#     def draw_middle_line(control_letter)
#       grid_size = GRID_SIZES[control_letter]
#       row = Array.new(grid_size, ' ')
#       row[0] = control_letter
#       row[-1] = control_letter
#       row
#     end

#     def draw_top(grid_size)
#       letter = 'A'
#       diamond = []
#       middle_index = grid_size / 2
#       (0..(grid_size / 2 - 1)).map do |offset|
#         row = Array.new(grid_size, ' ')
#         row[middle_index - offset] = letter
#         row[middle_index + offset] = letter
#         letter = letter.next
#         row
#       end
#     end
#   end
# end

# LS solution
# class Diamond
#   def self.make_diamond(letter)
#     range = ('A'..letter).to_a + ('A'...letter).to_a.reverse
#     diamond_width = max_width(letter)

#     range.each_with_object([]) do |let, arr|
#       arr << make_row(let).center(diamond_width)
#     end.join("\n") + "\n"
#   end

#   class << self
#     private

#     def make_row(letter)
#       return "A" if letter == "A"
#       return "B B" if letter == "B"

#       letter + determine_spaces(letter) + letter
#     end

#     def determine_spaces(letter)
#       all_letters = ['B']
#       spaces = 1

#       until all_letters.include?(letter)
#         current_letter = all_letters.last
#         all_letters << current_letter.next
#         spaces += 2
#       end

#       ' ' * spaces
#     end

#     def max_width(letter)
#       return 1 if letter == 'A'

#       determine_spaces(letter).count(' ') + 2
#     end
#   end
# end
