require_relative 'rules/transaction_amount_rule'
require_relative 'rules/consecutive_transactions_rule'
require_relative 'rules/chargeback_rule'
require_relative 'scores/transaction_amount_score'
require_relative 'scores/time_score'
require_relative 'scores/device_score'

class TransactionValidator
  attr_reader :transaction

  RULES = [
    TransactionAmountRule,
    ConsecutiveTransactionsRule,
    ChargebackRule
  ]

  SCORES = [
    TimeScore,
    TransactionAmountScore,
    DeviceScore
  ]
  def initialize(transaction)
    @transaction = transaction
  end

  def evaluate_transaction
    rule_results = RULES.map { |rule| {status: rule.decline(transaction), rule: rule.to_s } }

    if rule_results.any? { |result| result[:status] == true }
      return rule_results.find { |result| result[:status] == true }.merge(status: :declined)
    end

    transaction_score = SCORES.reduce(0) { |score, score_calculator| score + score_calculator.score(transaction) }

    if transaction_score >= ENV.fetch('transaction_score_threshold', 70)
      { status: :declined, score: transaction_score }
    else
      { status: :approved, score: transaction_score }
    end
  end
end