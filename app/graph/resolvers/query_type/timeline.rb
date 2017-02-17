module Resolvers
  module QueryType
    class Timeline < Base
      def resolve
        cache_for(:timeline).expires_in 15.minutes
        Time.use_zone(timezone) do
          OpenStruct.new(
            date: date,
            filters: filters,
            limit: limit,
            timezone: timezone,
            type: type
          )
        end
      end

      private

      def date
        return if last_story.blank?
        Time.use_zone(timezone) { Time.zone.at(last_story.published_at).at_beginning_of_day }
      end

      def cursor
        return Time.zone.at(args['cursor']).at_beginning_of_day unless args['cursor'].to_i.zero?
        Time.zone.now.at_beginning_of_day
      end

      def filters
        args.slice('category_slug', 'popular', 'publisher_slug').merge(popular: true)
      end

      def limit
        args['limit'].to_i
      end

      def timezone
        args['timezone'] || 'UTC'
      end

      def type
        args['type'].try(:to_sym) || :home
      end

      def last_story
        ::Story.filter(filters).published_until(cursor).reorder(:published_at).last
      end

      memoize :date, :cursor, :filters, :last_story, :limit, :timezone, :type
    end
  end
end
