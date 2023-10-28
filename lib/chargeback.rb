class Chargeback
  def call(transaction_id:, user_id:)
    transactions = $redis.fetch("transactions:#{user_id}") || []

    transactions = transactions.map do |transaction|
      transaction['chargeback'] = true if transaction['transaction_id'] == transaction_id

      transaction
    end

    $redis.set("transactions:#{user_id}", transactions.to_json)
  end
end