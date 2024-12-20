# Custom Set

=begin

P:

Create a custom Set type.

Assume all elements of the Set are numbers (can't be mutated)

Etc:

DS:

CustomSet class
#initialize(arr = [])
  @internal_arr = uniq arr

#empty?
#contains?( possible_member )
#subset?(other set)
  a set is a subset of an identical set
  an empty set is a subset of any set
  we are asking if the caller is a subset of the arg
#disjoint?(other set)
  two sets are disjoint if they have no common members
  an empty set is disjoint with any set
#eql?(other set)
  must have same elements, order not important
  could piggyback on Array#eql? first sorting both internal arrays
  internal arrays must of course be uniq, so duplicates do not matter
#add(member)
#intersection(other set)
  intersection of an empty set and a non-empty is an empty set
  intersection of disjoint sets is an empty set
  intersection should be sorted
#difference(other set)
  difference of empty sets is an empty set
  the difference when subtrahend has elements not in caller
    ignores disjoint elements
#==(other set)
  similar to eql? in approach but use Array#==
#union(other set)
  union of empty sets is an empty set
  union adds uniq members

A:

=end

class CustomSet
  def initialize(arr = [])
    @array = arr.uniq
  end

  def empty?
    array.empty?
  end

  def contains?(member)
    array.include?(member)
  end

  def subset?(other)
    array.all? do |member|
      other.contains?(member)
    end
  end

  def disjoint?(other)
    array.none? do |member|
      other.contains?(member)
    end
  end

  def eql?(other)
    array.sort.eql? other.array.sort
  end

  def add(member)
    array << member unless array.include?(member)
    self
  end

  def intersection(other)
    CustomSet.new(array.intersection(other.array).sort)
  end

  def difference(other)
    CustomSet.new(array - other.array)
  end

  def ==(other)
    array.sort == other.array.sort
  end

  def union(other)
    CustomSet.new(array.union(other.array).sort)
  end

  protected

  attr_reader :array
end

# 32:07
# 32:49 passed rubocop
