module Resolvers
  module QueryType
    class Timeline < Base
      def resolve
        cache_for(:timeline).expires_in 15.minutes
        OpenStruct.new(date: date, filters: filters, limit: limit, type: type)
      end

      private

      def date
        return if last_story.blank?
        Time.zone.at(last_story.published_at).at_beginning_of_day
      end

      def cursor
        return Time.zone.at(args['cursor']).at_beginning_of_day unless args['cursor'].to_i.zero?
        Time.zone.now.end_of_day
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

      memoize :date, :cursor, :filters, :last_story, :limit, :type
    end
  end
end
