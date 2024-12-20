# Diamond

=begin

P:

Write a program that takes a letter as input and outputs
it in a diamond shape. Given a letter, it prints a diamond
starting with 'A' with the supplied letter at the widest point.

The first row and last each contain one 'A' (centered)
All rows except the first and last have 2 identical letters
The diamond is horizontally and vertically symmetric in ASCII grid.
The diamond has a square shape
The top half has the letters in ascending order
The bottom half has the letters in descending order

Etc:

input: A
->
A

letter 1 (0 if 0 indexed)
grid 1

input: B

 A
B B
 A

letter 2 (1 if 0 indexed)
grid 3

input: C
->
  A
 B B
C   C
 B B
  C
letter 3 (2 if 0 indexed)
grid 5

input: D

   A
  B B
 C   C
D     D
 C   C
  B B
   A

letter 4
grid 7

input: E

    A
   B B
  C   C
 D     D
E       E
 D     D
  C   C
   B B
    A

E is 5th letter
7 spaces between Es
We can use centering for outer spaces
9 wide at widest point
9 rows

the letter input is related to number
A - 1 row
B - 3 rows
C - 5 rows
This is easy though because we can iterate chars forward
Would be more difficult to iterate back to 'A'

spacing before letters and between is odd numbers
except special case A -> 0 spaces before or between

A more algorithmic/programmatic way to determine grid size
would simply be to iterate from 'A' to input letter
call this count
then grid_size = count + (count - 1)
So 'A' to 'A' is 1
grid size 1 + (1-1) = 1
'A' to 'B' = 2
grid size = 2 + 1 = 3
'A' to 'E' = 5
grid = 5 + 4 = 9

widest point internal spacing = grid_size - 2
0 + 1 + 2 + 2 + 2

Always center 'A' in grid size
then 'B' + 1 space + 'B'
then add 2 spaces, and so on

"A".center(grid_size) and a "\n"
call it spaces = 1
(current_letter + " " * spaces + current_letter).center(grid) + "\n"
and so on

The spaces are related to letters as well though
A always 0
B always 1
C = 1 + 2
D = 1 + 2 + 2

DS:

A:
#make_diamond
Given a string, letter
Set grid_size := calculate_grid_size(letter)
Set result := empty string
iterate from 'A' to letter inclusive, current_letter
  result << make_row(current_letter, grid_size)
reverse iterate from 'A' to letter exclusive, current_letter
  result << make_row(current_letter, grid_size)
end
Return result

=end

class Diamond
  class << self
    def make_diamond(letter)
      grid_size = calculate_grid_size(letter)
      result = []

      ('A'..letter).each do |current_letter|
        result << make_row(current_letter, grid_size)
      end
      ('A'...letter).reverse_each do |current_letter|
        result << make_row(current_letter, grid_size)
      end

      "#{result.join("\n")}\n"
    end

    private

    def make_row(letter, grid_size)
      return 'A'.center(grid_size) if letter == 'A'

      (letter + spaces(letter) + letter).center(grid_size)
    end

    def spaces(letter)
      number_of_spaces = ('B'...letter).reduce(1) { |result, _| result + 2 }
      ' ' * number_of_spaces
    end

    def calculate_grid_size(letter)
      first = ('A'..letter).count
      first + first - 1
    end
  end
end

# 45:26
# 49:30 with rubocop passing
# should have worked through main method in algorithm section
# just to work out a plan for the second half
# 52:55 refactoring to avoid silly clumsiness
