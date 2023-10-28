require_relative 'rules/transaction_amount_rule'
require_relative 'rules/consecutive_transactions_rule'
require_relative 'rules/chargeback_rule'

class TransactionValidator
  attr_reader :transaction
  
  RULES = [
    TransactionAmountRule,
    ConsecutiveTransactionsRule,
    ChargebackRule
  ]

  def initialize(transaction)
    @transaction = transaction
  end

  def evaluate_transaction
    return :declined if RULES.any? { |rule| rule.call(transaction) }
    
    transaction_score = SCORES.reduce(0) { |score, score_calculator| score + score_calculator.score(transaction) }

    if transaction_score >= Env.fetch(:transaction_score_threshold, 70)
      :declined
    else
      :approved
    end
  end
end