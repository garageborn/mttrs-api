module Resolvers
  module TimelineType
    class Stories
      class PopularTimeline < Base
        delegate :date, :filters, :limit, to: :obj
        ALLOWED_FILTERS = %w(publisher_ids publisher_slug tag_slug with_summary).freeze
        STORIES_PER_CATEGORY = 2

        class << self
          def filters(args)
            args.slice(*ALLOWED_FILTERS).merge(popular: true)
          end

          def last_story(filters:, cursor:)
            cursor = parse_cursor(cursor)
            ::Story.filter(filters).published_until(cursor).reorder(:published_at).last
          end

          def parse_cursor(cursor)
            return Time.zone.now.end_of_day if cursor.to_i.zero?
            Time.zone.at(cursor).at_beginning_of_day
          end
        end

        def resolve
          return [] if date.blank?
          ::Story.where(id: stories_ids).filter(filters).published_between(start_at, end_at).
            limit(limit)
        end

        private

        def start_at
          date.at_beginning_of_day
        end

        def end_at
          date.end_of_day
        end

        def stories_ids
          return categories_stories_ids unless missing_stories_count.positive?
          categories_stories_ids + fallback_stories_ids
        end

        def categories_stories_ids
          ::Category.with_stories.map do |category|
            category_stories(category).map(&:id)
          end.flatten.compact.uniq
        end

        def category_stories(category)
          category.stories.filter(filters).published_between(start_at, end_at).
            limit(STORIES_PER_CATEGORY)
        end

        def fallback_stories_ids
          ::Story.filter(filters).published_between(start_at, end_at).
            where.not(id: categories_stories_ids).limit(missing_stories_count).map(&:id)
        end

        def missing_stories_count
          limit - categories_stories_ids.size
        end

        memoize :categories_stories_ids, :fallback_stories_ids, :stories_ids, :start_at, :end_at
      end
    end
  end
end
