# 1. Triangles

=begin

P:

Write a program to determine whether a triangle is
  equilateral, - all sides same length
  isosceles,   - exactly two sides same length
  or scalene.  - all sides different lengths

For a triangle to be a triangle at all,
  all sides must be of length > 0
  the sum of the lengths of any two sides must be greater than the length
    of the third side

Etc:

triangle(3, 4, 5) -> scalene
[3, 4, 5] all? > 0

a b c

a + b > c ? 3 + 4 > 5
b + c > a ? 4 + 5 > 3
a + c > b ? 3 + 5 > 4

tally sides
if the tally contains no value > 1 -> scalene
   the tally contains value of 2 -> isosceles
   tally contains value of 3 -> equilateral

3 => 1
4 => 1
5 => 1

[1, 1, 1]

DS:
input: individual numbers, side1, side2, side3
sides array [side1, side2, side3]
side_count tally hash, but we want to interrogate values array

Use ArgumentError to signal that one or more arguments invalidate the triangle
Could do a type check for Numeric arguments, but that's not very Rubyish

A:
Given three Numerics, side1, side2, side3
Set sides := array of side1, side2, side3
If any of sides <= 0 OR
    side1 + side2 <= side3 OR
    side1 + side3 <= side2 OR
    side2 + side3 <= side1
  Raise ArgumentError,
    "arguments must describe side lengths of non-degenerate triangle."

Set counts := values only of a tally of counts of sides
If counts includes 3
  Return "equilateral"
Else if counts includes 2
  Return "isosceles"
Else
  Return "scalene"
=end

class Triangle
  attr_reader :side1, :side2, :side3

  def initialize(side1, side2, side3)
    raise ArgumentError unless valid_triangle(side1, side2, side3)

    @side1 = side1
    @side2 = side2
    @side3 = side3
  end

  def kind
    sides = [side1, side2, side3]
    counts = sides.tally.values
    if counts.include?(3)
      'equilateral'
    elsif counts.include?(2)
      'isosceles'
    else
      'scalene'
    end
  end

  private

  def valid_triangle(side1, side2, side3)
    sides = [side1, side2, side3]
    sides.all?(&:positive?) &&
      side1 + side2 > side3 &&
      side1 + side3 > side2 &&
      side2 + side3 > side1
  end
end

# LS solution
# class Triangle
#   attr_reader :sides # I would personally make this a manual getter with #dup

#   def initialize(side1, side2, side3)
#     @sides = [side1, side2, side3]
#     raise ArgumentError, "Invalid triangle lengths" unless valid?
#   end

#   def kind
#     if sides.uniq.size == 1
#       'equilateral'
#     elsif sides.uniq.size == 2
#       'isosceles'
#     else
#       'scalene'
#     end
#   end

#   private

#   def valid?
#     # LS version causes AbcSize cop to comlain
#     # should assign the array elements to variables
#     sides.min > 0 &&
#       sides[0] + sides[1] > sides[2] &&
#       sides[1] + sides[2] > sides[0] &&
#       sides[0] + sides[2] > sides[1]
#   end
# end
