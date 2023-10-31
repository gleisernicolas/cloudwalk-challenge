require_relative 'base_rule'

class ConsecutiveTransactionsRule < BaseRule
  def call
    return false unless previous_transactions.any?

    return true if previous_transactions.last['transaction_amount'] == transaction.transaction_amount
    return true if transactions_in_last_2_minutes?

    false
  end

  def transactions_in_last_2_minutes?
    previous_transactions.any? do |previous_transaction|
      (Time.parse(previous_transaction['transaction_date']) - Time.parse(transaction.transaction_date)).abs <= 120
    end
  end
end