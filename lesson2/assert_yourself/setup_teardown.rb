require 'minitest/autorun'
require 'pg'

class MyApp
  def initialize
    @db = PG.connect 'mydb'
  end

  def cleanup
    @db.finish
  end

  def count; ...; end
  def create(value); ...; end
end

class DatabaseTest < Minitest::Test
  def setup
    @myapp = MyApp.new
  end

  def test_that_query_on_empty_database_returns_nothing
    assert_equal 0, @myapp.count
  end

  def test_that_query_on_non_empty_database_returns_right_count
    @myapp.create('Abc')
    @myapp.create('Def')
    @myapp.create('Ghi')
    assert_equal 3, @myapp.count
  end

  def teardown
    @myapp.cleanup
  end
end
