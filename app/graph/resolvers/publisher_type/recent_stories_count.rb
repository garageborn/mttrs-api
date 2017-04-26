module Resolvers
  module PublisherType
    class RecentStoriesCount < Base
      def resolve
        obj.stories.published_since(recent_days_ago).size
      end

      private

      def recent_days_ago
        ::Resolvers::QueryType::Timeline::RECENT_DAYS_AGO.days.ago.at_beginning_of_day
      end
    end
  end
end
