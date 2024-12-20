# Simple Linked List

=begin

P:

Implement a singly linked list.

Each element in the list contains
a data field and a next pointer

LIFO stack

Provide methods to reverse the list and
convert to and from an array

Etc:

DS:

class SimpleLinkedList - encapsulates Element object (head)
  which encapsulates the next Element, etc until the tail

::from_a(array arr)
  instantiate new list from arr

#initialize(array arr = nil)
  if arr is not nil && arr is not empty
    contruct list from array
  else
    default construct

#size
#empty?
#push
#pop
#peek
#head
#reverse
#to_a

A:

=end

class Element
  attr_accessor :datum, :next

  def initialize(datum, next_pointer = nil)
    @datum = datum
    @next = next_pointer
  end

  def tail?
    !@next  # LS @next.nil?
  end
end

class SimpleLinkedList
  attr_reader :head

  def initialize(arr = nil)
    @head = nil
    return unless !arr.nil? && !arr.empty?
    construct_list_from(arr)
  end

  def size
    return 0 unless head
    result = 1
    current_element = head
    until current_element.tail?
      current_element = current_element.next
      result += 1
    end
    result
  end

  def empty?
    size == 0
  end

  def push(datum)
    element = Element.new(datum)
    element.next = head
    @head = element
    self
  end

  def peek
    head&.datum
  end

  def pop
    return unless head
    old_head = head
    @head = head.next
    old_head.datum
  end

  def self.from_a(arr = nil)
    SimpleLinkedList.new(arr)
  end

  def to_a
    return [] unless head

    result = []
    current_element = head
    while current_element
      result.push(current_element.datum)
      current_element = current_element.next
    end
    result
  end

  def reverse
    new_list = SimpleLinkedList.new
    return new_list unless head

    current_element = head
    while current_element
      new_list.push(current_element.datum)
      current_element = current_element.next
    end

    new_list
  end

  private

  def construct_list_from(arr)
    arr.reverse_each { |datum| push(datum) }
  end

  def find_tail
    return unless head
    current_element = head
    current_element = current_element.next until current_element.tail?
    current_element
  end
end

# 50:55
# 52:01 rubocop passed

# LS solution

# class Element
#   attr_reader :datum, :next

#   def initialize(datum, next_element = nil)
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
#     while current_elem
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
#     # I would return self here to make it more like a Ruby core DS
#   end

#   def peek
#     @head.datum if @head  # rubocop says use safe navigation operator
#   end

#   def pop
#     datum = peek
#     new_head = @head.next  # not sure why we need this variable
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
#     current_elem = head
#     while !current_elem.nil?
#       list.push(current_elem.datum)
#       current_elem = current_elem.next
#     end
#     list
#   end
# end
