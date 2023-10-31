class BaseScore
  attr_reader :transaction

  def self.score(transaction)
    self.new(transaction).call
  end

  def initialize(transaction)
    @transaction = transaction
  end

  def call
    raise NotImplementedError
  end

  def previous_transactions
    @previous_transactions ||= fetch_previous_transactions
  end

  def fetch_previous_transactions
    transactions = $redis.get("transactions:#{transaction.user_id}")

    return [] unless transactions

    parsed_transactions = JSON.parse(transactions)

    parsed_transactions.sort_by { |transaction| DateTime.parse(transaction['transaction_date']) }.reverse
  end
end