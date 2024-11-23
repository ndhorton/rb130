# 5. Simple Linked List

=begin

P:

Implement a simple linked list.

Singly-linked list. Each node has data and next.

Etc:
Head is always most recently pushed item

class Element
  #initialize(datum, next = nil) - save in instance variables
  #datum - value
  #next - pointer to next element
  #tail? - is next nil?

class SimpleLinkedList
  ::from_a - initialize linked list from array or nil (empty list)
    if not nil, we need to iterate through array backwards
      so that start of array == most recently pushed
  #initialize(default args)
  #push - will have to adjust size
  #pop - pop most recently pushed, will have to adjust size
  #peek - look at top of stack without popping
  #head - most recently pushed element
  #size - return @size
  #empty? - @size = 0
  #to_a - iterate through list pushing to array
  #reverse

reverse approach:
unnecessary, since we can only instantiate ::from_a array
iterate through list building another list in reverse
so FORGET THIS
orig = @head
copy1 = copy(orig)
orig = orig.next
iterate until orig.tail?
  copy2 = make_copy(orig)
  copy2.next = copy1
  copy1 = copy2
  orig = orig.next
copy2 = make_copy(orig)
copy2.next = copy1
Instantiate SingleLinkedList with copy2 as @head

DS:

Element is a node
SimpleLinkedList is a pushdown lifo stack via singly linked list
Need array as intermediate form for reverse

A:
#build_list
Given an array, array
iterate backwards through array
  push(array element)

=end

class Element
  attr_reader :datum
  attr_accessor :next

  def initialize(datum, next_element = nil)
    @datum = datum
    @next = next_element
  end

  def tail?
    @next.nil?
  end
end

class SimpleLinkedList
  attr_accessor :head

  def initialize
    @head = nil
  end

  def push(datum)
    current = Element.new(datum, head)
    self.head = current
    self
  end

  def pop
    datum = head.datum
    self.head = head.next
    datum
  end

  def empty?
    head.nil?
  end

  def peek
    head&.datum
  end

  def to_a
    result = []

    current = head
    while current
      result << current.datum
      current = current.next
    end

    result
  end

  def reverse
    reversed_list = SimpleLinkedList.new

    current = head
    while current
      reversed_list.push(current.datum)
      current = current.next
    end

    reversed_list
  end

  def size
    result = 0

    current = head
    while current
      result += 1
      current = current.next
    end

    result
  end

  def self.from_a(arr)
    arr ||= []
    list = SimpleLinkedList.new

    arr.reverse_each do |datum|
      list.push(datum)
    end

    list
  end
end

# 1:14:11 - should definitely have spent more time understanding the problem

# LS solution
# class Element
#   attr_reader :datum, :next

#   def initialize(datum, next_element = nil)  # avoids shadowing keyword
#     @datum = datum
#     @next = next_element
#   end

#   def tail?
#     @next.nil?
#   end
# end

# class SimpleLinkedList
#   attr_reader :head

#   def size
#     size = 0
#     current_elem = @head
#     while (current_elem)
#       size += 1
#       current_elem = current_elem.next
#     end
#     size
#   end

#   def empty?
#     @head.nil?
#   end

#   def push(datum)
#     element = Element.new(datum, @head)
#     @head = element
#   end

#   def peek
#     @head.datum if @head
#   end

#   def pop
#     datum = peek
#     new_head = @head.next
#     @head = new_head
#     datum
#   end

#   def self.from_a(array)
#     array = [] if array.nil?

#     list = SimpleLinkedList.new
#     array.reverse_each { |datum| list.push(datum) }

#     list
#   end

#   def to_a
#     array = []

#     current_elem = head
#     while !current_elem.nil?
#       array.push(current_elem.datum)
#       current_elem = current_elem.next
#     end

#     array
#   end

#   def reverse
#     list = SimpleLinkedList.new
#     current_elem = @head
#     while !current_elem.nil?
#       list.push(current_elem.datum)
#       current_elem = current_elem.next
#     end
#     list
#   end
# end
