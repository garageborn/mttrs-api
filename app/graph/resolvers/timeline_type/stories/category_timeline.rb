module Resolvers
  module TimelineType
    class Stories
      class CategoryTimeline < Base
        delegate :filters, :date, :limit, to: :obj

        def resolve
          return [] if date.blank?
          ::Story.filter(filters).published_between(start_at, end_at).limit(limit)
        end

        def self.filters(args)
          allowed_filters = %w(category_slug tag_slug with_summary)
          args.slice(*allowed_filters).merge(popular: true)
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
