module Resolvers
  module TimelineType
    class Date < Base
      PER_CATEGORY = 2
      delegate :cursor, :filters, :timezone, to: :obj

      def resolve
        return if last_story.blank?
        Time.use_zone(timezone) { Time.zone.at(last_story.published_at).at_beginning_of_day }
      end

      private

      def published_at
        Time.use_zone(timezone) { Time.zone.at(cursor).at_beginning_of_day }
      end

      def last_story
        ::Story.filter(filters).published_until(published_at).reorder(:published_at).last
      end

      memoize :last_story, :published_at
    end
  end
end
