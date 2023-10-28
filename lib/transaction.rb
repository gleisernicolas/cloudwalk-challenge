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
    @transaction_amount = transaction_amount
  end

  def status
    @status ||= TransactionValidator.new(self).evaluate_transaction
  end
end