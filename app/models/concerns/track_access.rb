module Concerns
  module TrackAccess
    extend ActiveSupport::Concern

    included do
      has_many :accesses, as: :accessable, dependent: :destroy

      scope :sort_by_hits, lambda {
        left_outer_joins(:accesses).
          group("#{ table_name }.#{ primary_key }").
          reorder('COALESCE(SUM(accesses.hits), 0) DESC')
      }

      scope :hits_by_timeframe, lambda { |timeframe, time|
        time ||= Time.now.utc
        range = time.send("beginning_of_#{ timeframe }")..time.send("end_of_#{ timeframe }")
        where(accesses: { date: range })
      }
      scope :sort_by_hour_hits, ->(hour) { sort_by_hits.hits_by_timeframe(:hour, hour) }
      scope :sort_by_day_hits, ->(day) { sort_by_hits.hits_by_timeframe(:day, day) }
      scope :sort_by_month_hits, ->(month) { sort_by_hits.hits_by_timeframe(:month, month) }
      scope :sort_by_year_hits, ->(year) { sort_by_hits.hits_by_timeframe(:year, year) }
    end

    def hits
      accesses.sum(:hits)
    end
  end
end
