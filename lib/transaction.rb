require_relative 'transaction_validator'

class Transaction
  attr_reader :transaction_id, :merchant_id, :user_id, :card_number, :device_id, :transaction_date, :transaction_amount
  
  def initialize(transaction_id:, merchant_id:, user_id:, card_number:, device_id:, transaction_date:, transaction_amount:)
    @transaction_id = transaction_id
    @merchant_id = merchant_id
    @user_id = user_id
    @card_number = card_number
    @device_id = device_id
    @transaction_date = transaction_date
    @transaction_amount = transaction_amount.to_f
  end

  def status
    @status ||= TransactionValidator.new(self).evaluate_transaction
  end

  def update_previous_transactions
    return if previous_transactions.any?{ |transaction| transaction['transaction_id'] == transaction_id }

    previous_transactions << self.to_hash
    $redis.set("transactions:#{user_id}", previous_transactions.to_json)
  end

  def to_hash
    {
      transaction_id: transaction_id,
      merchant_id: merchant_id,
      user_id: user_id,
      card_number: card_number,
      device_id: device_id,
      transaction_date: transaction_date,
      transaction_amount: transaction_amount,
      transaction_status: status
    }
  end

  def previous_transactions
    @previous_transactions ||= fetch_previous_transactions
  end

  def fetch_previous_transactions
    transactions = $redis.get("transactions:#{user_id}")

    return [] unless transactions

    parsed_transactions = JSON.parse(transactions)
    parsed_transactions.sort_by { |transaction| DateTime.parse(transaction['transaction_date']) }.reverse
  end
end