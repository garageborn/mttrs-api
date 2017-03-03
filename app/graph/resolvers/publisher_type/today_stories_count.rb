module Resolvers
  module PublisherType
    class TodayStoriesCount < Base
      def resolve
        obj.stories.today.size
      end
    end
  end
end
