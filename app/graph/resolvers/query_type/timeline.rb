module Resolvers
  module QueryType
    class Timeline < Base
      def resolve
        cache_for(:timeline).expires_in 15.minutes
        OpenStruct.new(
          cursor: cursor,
          filters: filters,
          limit: limit,
          timezone: timezone,
          type: type
        )
      end

      private

      def cursor
        Time.use_zone(timezone) do
          return args['cursor'] unless args['cursor'].to_i.zero?
          Time.zone.now.at_beginning_of_day
        end.to_i
      end

      def filters
        args.slice('category_slug', 'popular', 'publisher_slug', 'recent')
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

      memoize :cursor, :filters, :limit, :timezone, :type
    end
  end
end
