require_relative 'base_rule'

class ChargebackRule < BaseRule
  def call
    previous_transactions.any? { |previous_transaction| previous_transaction['chargeback'] == true }
  end
end