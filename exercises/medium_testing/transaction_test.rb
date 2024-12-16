require 'minitest/autorun'
require_relative 'transaction'

class TransactionTest < Minitest::Test
  def test_for_payment
    transaction = Transaction.new(30)
    input = StringIO.new("30\n")
    output = StringIO.new
    transaction.prompt_for_payment(input: input, output: output)
    
    assert_equal 30, transaction.amount_paid
  end

  def test_prompt_for_payment_output
    item_cost = 25
    input = StringIO.new("20\n25\n")
    transaction = Transaction.new(item_cost)
    initial = "You owe $#{item_cost}.\nHow much are you paying?\n"
    error = "That is not the correct amount. " \
      "Please make sure to pay the full cost.\n"

    assert_output("#{initial}#{error}#{initial}") do
      transaction.prompt_for_payment(input: input)
    end
  end
end