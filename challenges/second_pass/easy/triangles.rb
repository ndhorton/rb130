=begin
Triangles

P:
  Write a program to determine whether a triangle is
  equilateral, isosceles, or scalene

For a shape to be a triangle at all, all sides must be
of length > 0, and the sum of the lengths of any two sides
must be greater than the length of the third side.

To determine triangle type:
Make a hash of counts
If the maximum value in the value part of hash is 3,
  equilateral
If the maximum value is 2
  isosceles
Else
  scalene

Etc:

All lengths the same -> equilateral
Only two lengths the same -> isosceles
No lengths the same -> scalene

DS:
Triangle class
#initialize - takes three lengths
  raises ArgumentError if any length <= 0
  raises ArgumentError if lengths do not
    describe a valid triangle
#kind -> String representing type of triangle

A:
#initialize(side1, side2, side3)
If valid_triangle?(side1, side2, side3)
  set instance variables @side1, @side2, @side3
Else
  Raise exception

#valid_triangle?
Given three Numerics, side1, side2, side3
Iterate over three sides
  if current side <= 0
    return false
determine whether side1 + side2 > side3 and
side1 + side3 > side2 and
side2 + side3 > side1
Return boolean result

#kind
Set tallies := empty hash with default value 0
iterate over @side1, @side3, @side3
  increment tallies[current_side]
Case maximum values of tallies
  when 3 return 'equilateral'
  when 2 return 'isosceles'
  else   return 'scalene'

=end

class Triangle
  def initialize(side1, side2, side3)
    if valid_triangle?(side1, side2, side3)
      @side1 = side1
      @side2 = side2
      @side3 = side3
    else
      raise ArgumentError, "arguments must describe valid triangle"
    end
  end

  def kind
    counts = Hash.new(0)
    [@side1, @side2, @side3].each { |side| counts[side] += 1 }
    case counts.values.max
    when 3 then 'equilateral'
    when 2 then 'isosceles'
    else        'scalene'
    end
  end

  private

  def valid_triangle?(side1, side2, side3)
    return false if [side1, side2, side3].any? { |side| side <= 0 }
    side1 + side2 > side3 &&
      side1 + side3 > side2 &&
      side2 + side3 > side1
  end
end