require_relative 'base_score'
class DeviceScore < BaseScore
  def call
    return 20 if previous_transactions.any?{ |prev_transaction| prev_transaction['device_id'] != transaction.device_id }

    0
  end
end