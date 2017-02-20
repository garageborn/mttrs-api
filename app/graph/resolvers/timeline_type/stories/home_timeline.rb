module Resolvers
  module TimelineType
    class Stories
      class HomeTimeline < Base
        PER_CATEGORY = 2

        delegate :filters, :date, :limit, to: :obj

        def resolve
          categories.each { |category| stories.concat(category_stories(category)) }
          stories.concat(fallback_stories) if stories.size < limit
          stories
        end

        private

        def stories
          @stories ||= []
        end

        def categories
          ::Category.ordered.all
        end

        def category_stories(category)
          category_stories = []
          stories = category.stories.filter(filters).published_between(start_at, end_at).
                    where.not(id: current_story_ids)
          stories.each do |story|
            category_stories << story if story.main_category == category
            break if category_stories.size == PER_CATEGORY
          end
          category_stories
        end

        def fallback_stories
          missing_stories_count = limit - stories.size
          ::Story.filter(filters).published_between(start_at, end_at).
            where.not(id: current_story_ids).limit(missing_stories_count)
        end

        def current_story_ids
          stories.map(&:id)
        end

        def start_at
          date.at_beginning_of_day
        end

        def end_at
          date.end_of_day
        end

        memoize :categories, :stories, :start_at, :end_at
      end
    end
  end
end
