require 'simplecov'
require 'minitest/autorun'
require "minitest/reporters"
SimpleCov.start
Minitest::Reporters.use!

require_relative 'todolist'

class TodoListTest < Minitest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal @todos, @list.to_a
  end

  def test_size
    assert_equal 3, @list.size
  end

  def test_first
    assert_equal @todo1, @list.first
  end

  def test_last
    assert_equal @todo3, @list.last
  end

  def test_shift
    removed_todo = @list.shift

    assert_equal @todo1, removed_todo
    assert_equal [@todo2, @todo3], @list.to_a
  end

  def test_pop
    # implemented TodoList#== for this test

    removed_todo = @list.pop
    expected_list = TodoList.new(@list.title)
    expected_list.add(@todo1)
    expected_list.add(@todo2)

    assert_equal @todo3, removed_todo
    assert_equal expected_list, @list
  end

  def test_done_question
    assert_equal false, @list.done?
  end

  def test_add_raise_error
    assert_raises(TypeError) { @list.add("non-todo object") }
    assert_raises(TypeError) { @list.add(:non_todo_object) }
    assert_raises(TypeError) { @list.add(1) }
    assert_raises(TypeError) { @list.add(1.0) }
    assert_raises(TypeError) { @list.add(1..10) }
    assert_raises(TypeError) { @list.add(Hash.new) }
    assert_raises(TypeError) { @list.add(Array.new) }
    assert_raises(TypeError) { @list.add(nil) }
  end

  def test_shovel
    new_todo = Todo.new("Walk the dog")
    @list << new_todo
    @todos << new_todo

    assert_equal(@todos, @list.to_a)
  end

  def test_add
    new_todo = Todo.new("Walk the dog")
    @list.add(new_todo)
    @todos << new_todo

    assert_equal @todos, @list.to_a
  end

  def test_item_at
    assert_raises(IndexError) { @list.item_at(100) }
    assert_equal @todo1, @list.item_at(0)
    assert_equal @todo2, @list.item_at(1)
    assert_equal @todo3, @list.item_at(2)
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(100) }
    
    @list.mark_done_at(1)
    
    assert_equal false, @list.item_at(0).done?
    assert_equal true, @list.item_at(1).done?
    assert_equal false, @list.item_at(2).done?
  end

  def test_mark_undone_at
    assert_raises(IndexError) { @list.mark_undone_at(100) }

    @todo1.done!
    @todo2.done!
    @todo3.done!

    @list.mark_undone_at(1)

    assert_equal true, @list.item_at(0).done?
    assert_equal false, @list.item_at(1).done?
    assert_equal true, @list.item_at(2).done?
  end

  def test_done_bang
    @list.done!

    assert_equal true, @list.item_at(0).done?
    assert_equal true, @list.item_at(1).done?
    assert_equal true, @list.item_at(2).done?
    assert_equal true, @list.done?
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(100) }

    removed_todo = @list.remove_at(1)

    assert_equal @todo2, removed_todo
    assert_equal [@todo1, @todo3], @list.to_a
  end

  def test_to_s
    output = <<~OUTPUT.chomp # To call a method on a heredoc place it after the opening identifier
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
  
    assert_equal output, @list.to_s
  end

  def test_to_s_2
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [X] Clean room
    [ ] Go to gym
    OUTPUT
    @list.mark_done_at(1)

    assert_equal output, @list.to_s
  end

  def test_to_s_3
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
    @list.done!

    assert_equal output, @list.to_s
  end

  def test_each
    results = []
    @list.each { |todo| results << todo }

    assert_equal [@todo1, @todo2, @todo3], results
  end

  def test_each_returns_original_list
    returned_object = @list.each { |_| nil }

    assert_same @list, returned_object
  end

  def test_select
    @todo1.done!
    list = TodoList.new(@list.title)
    list.add(@todo1)

    assert_equal(list.title, @list.title)
    assert_equal(list.to_s, @list.select { |todo| todo.done? }.to_s)
    refute_same(@list, @list.select { |todo| todo.done? })
  end

  def test_find_by_title
    assert_equal @todo1, @list.find_by_title("Buy milk")
  end

  def test_all_done
    new_list = TodoList.new(@list.title)
    new_list.add(@todo2)
    @list.mark_done_at(1)

    assert_equal new_list, @list.all_done
  end

  def test_all_not_done
    new_list = TodoList.new(@list.title)
    new_list.add(@todo2)
    @list.done!
    @list.mark_undone_at(1)

    assert_equal new_list, @list.all_not_done
  end

  def test_mark_done
    @list.mark_done("Buy milk")
    
    assert_equal true, @list.item_at(0).done?
  end

  def test_mark_all_done
    @list.mark_all_done

    assert_equal true, @list.item_at(0).done?
    assert_equal true, @list.item_at(1).done?
    assert_equal true, @list.item_at(2).done?
    assert_equal true, @list.done?
  end

  def test_mark_all_undone
    @todo1.done!
    @todo2.done!
    @todo3.done!
    @list.mark_all_undone

    assert_equal false, @todo1.done?
    assert_equal false, @todo2.done?
    assert_equal false, @todo3.done?
  end
end