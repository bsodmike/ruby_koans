# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
  a, b, c = [a, b, c].sort

  raise TriangleError, "The smallest side must be positive in length" if a <= 0
  raise TriangleError, "The sum of the two smallest sides must be greater than the largest side" if a + b <= c

  case
  when (a**3) == (a * b * c) # comparing side^3 when lengths are equal
    :equilateral
  when a == b || b == c || a == c
    :isosceles
  else
    :scalene
  end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
