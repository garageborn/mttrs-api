def category_stories(category:, stories:, start_at:, end_at:, filters:, limit:)
  category_stories = []
  current_story_ids = stories.map(&:id)
  stories = category.stories.filter(filters).published_between(start_at, end_at).
            where.not(id: current_story_ids)
  stories.each do |story|
    category_stories << story if story.main_category == category
    break if category_stories.size == limit
  end
  category_stories
end

def home_timeline_item(start_at:, end_at:, filters:)
  categories = Category.ordered.with_stories
  limit = filters.delete('limit').to_i
  per_category = 2

  Array.new.tap do |stories|
    categories.each do |category|
      category_stories = category_stories(
        category: category,
        stories: stories,
        limit: per_category,
        start_at: start_at,
        end_at: end_at,
        filters: filters
      )
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

def default_timeline_item(start_at:, end_at:, filters:)
  Story.filter(filters).published_between(start_at, end_at)
end

def resolve_timeline_item(start_at:, end_at:, type:, filters:)
  if type == 'home'
    home_timeline_item(start_at: start_at, end_at: end_at, filters: filters)
  else
    default_timeline_item(start_at: start_at, end_at: end_at, filters: filters)
  end
end

TimelineItemType = GraphQL::ObjectType.define do
  name 'Timeline Item Type'
  description 'Timeline Item Type'

  field :date, !types.Int
  field :timezone, !types.String
  field :type, !types.String
  field :stories, !types[StoryType] do
    argument :limit, types.Int
    argument :category_slug, types.String
    argument :limit, types.Int
    argument :popular, types.Boolean
    argument :publisher_slug, types.String
    argument :recent, types.Boolean
    resolve lambda { |obj, args, _ctx|
      start_at = Time.use_zone(obj.timezone) { Time.zone.at(obj.date).at_beginning_of_day }
      end_at = Time.use_zone(obj.timezone) { Time.zone.at(obj.date).end_of_day }
      resolve_timeline_item(start_at: start_at, end_at: end_at, type: obj.type, filters: args.to_h)
    }
  end
end
