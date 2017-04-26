module Resolvers
  module QueryType
    class Timeline < Base
      RECENT_DAYS_AGO = 1

      def resolve
        cache_for(:timeline).expires_in 15.minutes
        OpenStruct.new(
          date: date,
          filters: filters,
          limit: limit,
          type: type,
          start_at: start_at,
          end_at: end_at
        )
      end

      private

      def date
        return if last_story.blank?
        Time.zone.at(last_story.published_at).at_beginning_of_day
      end

      def cursor
        return recent_end_at if args['cursor'].to_i.zero?
        cursor = Time.zone.at(args['cursor']).at_beginning_of_day
        recent?(cursor) ? recent_start_at : cursor
      end

      def filters
        Resolvers::TimelineType::Stories.filters(type: type, args: args).with_indifferent_access
      end

      def limit
        args['limit'].to_i
      end

      def type
        args['type'].try(:to_sym) || :home
      end

      def last_story
        Resolvers::TimelineType::Stories.last_story(type: type, cursor: cursor, filters: filters)
      end

      def start_at
        return recent_start_at if recent?(date)
        date.at_beginning_of_day
      end

      def end_at
        return recent_end_at if recent?(date)
        date.end_of_day
      end

      def recent?(date)
        date > recent_start_at
      end

      def recent_start_at
        RECENT_DAYS_AGO.days.ago.at_beginning_of_day
      end

      def recent_end_at
        Time.zone.now.end_of_day
      end

      memoize :date, :cursor, :filters, :last_story, :limit, :type
    end
  end
end
