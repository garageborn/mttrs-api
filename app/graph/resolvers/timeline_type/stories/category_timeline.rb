module Resolvers
  module TimelineType
    class Stories
      class CategoryTimeline < Base
        delegate :filters, :date, :limit, to: :obj
        MIN_CATEGORY_SOCIAL = 300
        MIN_TAG_SOCIAL = 50

        class << self
          def filters(args)
            allowed_filters = %w(category_slug tag_slug with_summary)
            args.slice(*allowed_filters).merge(popular: true)
          end

          def last_story(filters:, cursor:)
            filter_stories(filters).published_until(cursor).reorder(:published_at).last
          end

          def filter_stories(filters)
            stories = ::Story.filter(filters)

            if filters[:tag_slug].present?
              stories = apply_min_total_social(stories, MIN_TAG_SOCIAL)
            elsif filters[:category_slug].present?
              stories = apply_min_total_social(stories, MIN_CATEGORY_SOCIAL)
            end
            stories
          end

          def apply_min_total_social(stories, min_total_social)
            stories.min_total_social(min_total_social).or(stories.with_summary)
          end
        end

        def resolve
          return [] if date.blank?
          self.class.filter_stories(filters).published_between(start_at, end_at).limit(limit)
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
