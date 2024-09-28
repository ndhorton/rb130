# 6. Custom Set

=begin

P:

Create a custom set type.

It must behave like a set of unique elements with the following operations.

Assume all elements are numbers.



Etc:

Set has no concept of order of elements
Set can only contain one of each element

use hash to store elements = true
#== can be Hash#==

CustomSet class
  #initialize - can accept no arg, array arg
  #empty?
  #contains?
  #subset? - takes set argument, asks if the caller is a subset of the argument
              empty  set is always a subset, a set is a subset of itself
  #disjoint? -
    "two sets are said to be disjoint if they have no elements in common.
    equivalently, two disjoint sets are sets whose intersection is
    the empty set" - wikipedia
    the empty set is disjoint with any set including itself
  
  #eql? - [class, all state] == other.[class, all state] (check this, think it uses hash function)
    order of elements passed to constructor should not affect truth value
    duplicate elements passed to constructor should not affect truth value
  #hash [self.class, @hash].hash
  
  #add - add an element to set, mutates caller, MUST return self
  #== - must have equivalent elements
  #intersection - returns new set that contains only the elements that are in 
    both caller and arg
    iterate through each key of one set
      if key is in other set
        add to new set
  #difference - subtracts arg from caller
    if arg contains elements not in caller, those elements are ignored
  #union - returns new set that has all the elements of both sets

DS:

Use hash to store set members with default value of false
When adding, insert new key => true
When comparing with ==, @hash == @hash
When comparing with eql?, hash -> [self.class, @hash] == other.hash ->[self.class, @hash]

#empty? - @hash.empty?
#contains? @hash[key] == true

A:

#subset?
Given a CustomSet, other
iterate through @hash.keys
all keys are true in other? (all? on empty collection returns true)

#disjoint?
like subset, but none?

#add
@hash[new_element] = true
return self

#intersection
Given a CustomSet, other
Instantiate new CustomSet, result
iterate through keys of @hash
  if other.contains? key
    result[key] = true


#difference
Given a CustomSet, other
Instantiate a new CustomSet, result
iterate through keys of @hash
  if other.contains? key
    next iteration
  result[key] = true
return result

#union
Given a CustomSet, other
Instantiate new CustomSet, result
Iterate through keys of @hash
  result[key] = true
Iterate through keys of other (how? with a protected `each` method?)
  result[key] = true
Return result
=end

class CustomSet
  def initialize(array = [])
    @set = {}
    array.each { |element| add(element) }
  end

  def empty?
    set.empty?
  end

  def contains?(element)
    set[element] == true
  end

  def subset?(other)
    set.keys.all? { |member| other.contains?(member) }
  end

  def disjoint?(other)
    set.keys.none? { |member| other.contains? (member) }
  end

  def add(element)
    set[element] = true
    self
  end

  def ==(other)
    set == other.set
  end

  def eql?(other)
    hash == other.hash
  end

  def hash
    [self.class, set].hash
  end

  def intersection(other)
    result = self.class.new
    set.keys.each do |member|
      if other.contains?(member)
        result.add(member)
      end
    end
    result
  end

  def difference(other)
    result = self.class.new
    set.keys.each do |member|
      next if other.contains?(member)
      result.add(member)
    end
    result
  end

  def union(other)
    result = self.class.new(set.keys)
    other.set.keys.each do |member|
      result.add(member)
    end
    result
  end

  protected

  attr_reader :set
end

# 1:10:08

# LS solution
# class CustomSet
#   def initialize(set = [])
#     @elements = set.uniq
#   end

#   def empty?
#     elements.empty?
#   end

#   def intersection(other_set)
#     same_elements = elements.select { |el| other_set.contains?(el) }
#     CustomSet.new(same_elements)
#   end

#   def union(other_set)
#     union_set = CustomSet.new(elements)
#     other_set.elements.each { |el| union_set.add(el) }
#     union_set
#   end

#   def difference(other_set)
#     different_elements = elements.select { |el| !other_set.contains?(el) }
#     CustomSet.new(different_elements)
#   end

#   def disjoint?(other_set)
#     elements.none? { |el| other_set.contains?(el) }
#   end

#   def eql?(other_set)
#     return false unless elements.length == other_set.elements.length
#     subset?(other_set)
#   end

#   def subset?(other_set)
#     elements.all? { |el| other_set.contains?(el) }
#   end

#   def add(element)
#     elements.push(element) unless contains?(element)
#     self
#   end

#   def contains?(element)
#     elements.include?(element)
#   end

#   def ==(other_set)
#     eql?(other_set)
#   end

#   protected

#   attr_accessor :elements
# end