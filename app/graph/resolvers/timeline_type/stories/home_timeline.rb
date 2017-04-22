module Resolvers
  module TimelineType
    class Stories
      class HomeTimeline < Base
        delegate :filters, :date, to: :obj

        def resolve
          return [] if date.blank?
          ::Story.filter(filters).published_between(start_at, end_at)
        end

        def self.filters(_args)
          { with_summary: true, order_by_summarized_at: true }
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
