class Access < ActiveRecord::Base
  belongs_to :accessable, polymorphic: true

  scope :by_timeframe, lambda { |timeframe, time|
    range = time.send("beginning_of_#{ timeframe }")..time.send("end_of_#{ timeframe }")
    where(date: range)
  }
  scope :by_hour, ->(hour) { by_timeframe(:hour, hour) }
  scope :by_day, ->(day) { by_timeframe(:day, day) }
  scope :by_month, ->(month) { by_timeframe(:month, month) }
  scope :by_year, lambda{ |year|
    year = DateTime.new(year) if year.is_a?(Integer)
    by_timeframe :year, year
  }
end
