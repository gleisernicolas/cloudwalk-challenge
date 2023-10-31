class Chargeback
  def self.call(transaction_id:, user_id:)
    transactions = $redis.get("transactions:#{user_id}")

    return unless transactions

    transactions = JSON.parse(transactions)
    transactions = transactions.map do |transaction|
      transaction['chargeback'] = true if transaction['transaction_id'] == transaction_id

      transaction
    end

    $redis.set("transactions:#{user_id}", transactions.to_json)
  end
end