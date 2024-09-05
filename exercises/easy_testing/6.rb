# Exception Assertions

require 'minitest/autorun'

class NoExperienceError < StandardError; end

class Employee
  def hire
    raise NoExperienceError
  end
end

class ExceptionTest < Minitest::Test
  def test_hire_raises
    employee = Employee.new

    assert_raises(NoExperienceError) { employee.hire }
  end
end