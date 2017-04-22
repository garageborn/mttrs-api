module Resolvers
  module TimelineType
    class Stories
      class PublisherTimeline < Base
        delegate :filters, :date, :limit, to: :obj

        class << self
          def filters(args)
            allowed_filters = %w(publisher_slug with_summary)
            args.slice(*allowed_filters).merge(popular: true)
          end

          def last_story(filters:, cursor:)
            ::Story.filter(filters).published_until(cursor).reorder(:published_at).last
          end
        end

        def resolve
          return [] if date.blank?
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
