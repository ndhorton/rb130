require 'minitest/autorun'
require_relative 'cash_register'
require_relative 'transaction'

class CashRegisterTest < Minitest::Test
  def test_accept_money
    register = CashRegister.new(1000)
    transaction = Transaction.new(20)
    transaction.amount_paid = 20
    
    previous_amount = register.total_money
    register.accept_money(transaction)
    current_amount = register.total_money

    assert_equal previous_amount + 20, current_amount
  end

  def test_change
    register = CashRegister.new(1000)
    transaction = Transaction.new(30)
    transaction.amount_paid = 40

    assert_equal 10, register.change(transaction)
  end

  def test_give_receipt
    item_cost = 35
    register = CashRegister.new(1000)
    transaction = Transaction.new(item_cost)

    assert_output("You've paid $#{item_cost}.\n") do
      register.give_receipt(transaction)
    end
  end
end

