module Resolvers
  module QueryType
    class Timeline < Base
      def resolve
        cache_for(:timeline).expires_in 15.minutes
        (start_at...end_at).map { |day| resolve_day(day) }
      end

      private

      def resolve_day(day)
        date = Time.use_zone(timezone) { day.days.ago.at_beginning_of_day.to_i }
        OpenStruct.new(date: date, timezone: timezone, type: type)
      end

      def start_at
        args['offset'].to_i
      end

      def end_at
        start_at + args['days'].to_i
      end

      def timezone
        args['timezone'] || 'UTC'
      end

      def type
        args['type']
      end

      memoize :start_at, :end_at, :timezone, :type
    end
  end
end
