module Resolvers
  module TimelineType
    class Stories
      class DefaultTimeline < Base
        delegate :filters, :date, :limit, to: :obj

        def resolve
          ::Story.filter(filters).published_between(start_at, end_at).limit(limit)
        end

        private

        def start_at
          date.at_beginning_of_day
        end

        def end_at
          date.end_of_day
        end

        memoize :start_at, :end_at
      end
    end
  end
end
