require_relative 'base_score'
class TransactionAmountScore < BaseScore
  def call
    return 50 if transaction.transaction_amount > ENV.fetch('transaction_amount_threshold', 1000)

    0
  end
end