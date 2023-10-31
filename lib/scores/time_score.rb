require_relative 'base_score'

class TimeScore < BaseScore
  HOUR_SCORE = {
    '22' => 30,
    '23' => 40,
    '00' => 50,
    '01' => 50,
    '02' => 50,
    '03' => 50,
    '04' => 50,
    '05' => 40,
    '06' => 30
  }.freeze

  def call
    parsed_time = DateTime.parse(transaction.transaction_date)
    HOUR_SCORE.fetch(parsed_time.hour.to_s, 0)

  rescue Date::Error => e
    100
  end
end