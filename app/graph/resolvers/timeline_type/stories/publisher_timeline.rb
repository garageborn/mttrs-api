module Resolvers
  module TimelineType
    class Stories
      class PublisherTimeline < Base
        delegate :date, :end_at, :filters, :limit, :start_at, to: :obj

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
      end
    end
  end
end
