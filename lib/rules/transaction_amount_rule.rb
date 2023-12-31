require_relative 'base_rule'

class TransactionAmountRule < BaseRule
  def call
    transaction.transaction_amount > transaction_amount_threshold && outside_hours?(transaction.transaction_date)

  rescue Date::Error
    true
  end

  def outside_hours?(transaction_datetime)
    parsed_time = DateTime.parse(transaction_datetime)
    time_start, time_end = ENV.fetch('transaction_time_threshold', '22-06').split('-').map(&:to_i)

    parsed_time.hour >= time_start || parsed_time.hour <= time_end
  end

  def transaction_amount_threshold
    ENV.fetch('transaction_amount_threshold', 1000)
  end
end
