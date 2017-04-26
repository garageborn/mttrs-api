module Resolvers
  module TimelineType
    class Stories
      class HomeTimeline < Base
        delegate :filters, :date, :start_at, :end_at, to: :obj

        class << self
          def filters(_args)
            { with_summary: true, order_by_summarized_at: true }
          end

          def last_story(filters:, cursor:)
            ::Story.filter(filters).published_until(cursor).reorder(:published_at).last
          end
        end

        def resolve
          return [] if date.blank?
          ::Story.filter(filters).published_between(start_at, end_at)
        end
      end
    end
  end
end
