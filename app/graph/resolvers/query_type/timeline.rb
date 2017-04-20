module Resolvers
  module QueryType
    class Timeline < Base
      def resolve
        cache_for(:timeline).expires_in 15.minutes
        OpenStruct.new(
          date: date,
          filters: filters,
          limit: limit,
          type: type
        )
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
        allowed_filters = %w(category_slug popular publisher_slug tag_slug with_summary)
        args.slice(*allowed_filters).merge(popular: true)
      end

      def limit
        args['limit'].to_i
      end

      def type
        args['type'].try(:to_sym) || :home
      end

      def last_story
        ::Story.filter(filters).published_until(cursor).reorder(:published_at).last
      end

      memoize :date, :cursor, :filters, :last_story, :limit, :type
    end
  end
end
