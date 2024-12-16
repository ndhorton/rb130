require 'minitest/autorun'

require_relative 'transaction'

class TransactionTest < Minitest::Test
  def test_prompt_for_payment_output
    item_cost = 35
    transaction = Transaction.new(item_cost)
    input = StringIO.new("#{item_cost - 10}\n#{item_cost}\n")
    output = "You owe $#{item_cost}.\nHow much are you paying?\n" +
      "That is not the correct amount. " +
      "Please make sure to pay the full cost.\n" +
      "You owe $#{item_cost}.\nHow much are you paying?\n"

    assert_output(output) do
      transaction.prompt_for_payment(input: input)
    end
  end

  def test_prompt_for_payment_sets_amount_paid_correctly
    item_cost = 35
    transaction = Transaction.new(item_cost)
    input = StringIO.new("#{item_cost}\n")
    output = StringIO.new

    transaction.prompt_for_payment(input: input, output: output)
    
 
    assert_equal item_cost, transaction.amount_paid
  end
end