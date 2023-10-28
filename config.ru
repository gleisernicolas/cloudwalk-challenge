require 'bundler/setup'
require 'hanami/api'
require 'hanami/middleware/body_parser'
require_relative 'lib/transaction'
require_relative 'lib/chargeback'
require 'redis'
require 'byebug'

use Hanami::Middleware::BodyParser, :json
class App < Hanami::API
  helpers do
    def transaction_params
      transaction_fields = %i[transaction_id merchant_id user_id card_number device_id transaction_date transaction_amount]

      params.select { |key, _| transaction_fields.include?(key.to_sym) }
    end

    def chargeback_params
      params.select { |key, _| %i[transaction_id user_id].include?(key.to_sym) }
    end
  end

  post '/evaluate_transaction' do
    byebug
    transaction_status = Transaction.new(*transaction_params).status

    json(transaction_params.merge(transaction_status: transaction_status))
  end

  post '/chargeback' do
    Chargeback.call(chargeback_params)

    json({ status: 'ok' })
  end
end
$redis = Redis.new
run App.new