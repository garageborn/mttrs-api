module Resolvers
  module TimelineItemType
    class Stories < Base
      PER_CATEGORY = 2

      def resolve
        return home_timeline_item if type == :home
        default_timeline_item
      end

      private

      def default_timeline_item
        Story.filter(filters).published_between(start_at, end_at)
      end

      def home_timeline_item
        categories = Category.ordered.with_stories

        Array.new.tap do |stories|
          categories.each do |category|
            category_stories = category_stories(category: category, stories: stories)
            stories.concat(category_stories)
          end

          if stories.size < limit
            missing_stories_count = limit - stories.size
            current_story_ids = stories.map(&:id)
            other_stories = Story.filter(filters).published_between(start_at, end_at).
                            where.not(id: current_story_ids).limit(missing_stories_count)
            stories.concat(other_stories)
          end
        end
      end

      def category_stories(category:, stories:)
        category_stories = []
        current_story_ids = stories.map(&:id)
        stories = category.stories.filter(filters).published_between(start_at, end_at).
                  where.not(id: current_story_ids)
        stories.each do |story|
          category_stories << story if story.main_category == category
          break if category_stories.size == PER_CATEGORY
        end
        category_stories
      end

      def start_at
        Time.use_zone(obj.timezone) { Time.zone.at(obj.date).at_beginning_of_day }
      end

      def end_at
        Time.use_zone(obj.timezone) { Time.zone.at(obj.date).end_of_day }
      end

      def type
        obj.type.to_sym
      end

      def limit
        args['limit'].to_i
      end

      def filters
        args.except('limit')
      end

      memoize :start_at, :end_at, :type, :limit, :filters
    end
  end
end
