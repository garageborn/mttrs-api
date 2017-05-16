QueryType = GraphQL::ObjectType.define do
  name 'QueryType'

  field :categories, !types[CategoryType] do
    argument :ordered, types.Boolean
    argument :order_by_name, types.Boolean
    argument :order_by_stories_count, types.Boolean
    argument :publisher_ids, types[types.Int]
    argument :with_stories, types.Boolean
    argument :tag_slug, types.String
    resolve Resolvers::QueryType::Categories
  end

  field :category, CategoryType do
    argument :slug, !types.String
    resolve Resolvers::QueryType::Category
  end

  field :link, LinkType do
    argument :slug, !types.String
    resolve Resolvers::QueryType::Link
  end

  field :publishers, !types[PublisherType] do
    argument :limit, types.Int
    argument :order_by_name, types.Boolean
    argument :with_ids, types[types.Int]
    argument :with_stories, types.Boolean
    resolve Resolvers::QueryType::Publishers
  end

  field :publisher, PublisherType do
    argument :slug, !types.String
    resolve Resolvers::QueryType::Publisher
  end

  field :story, StoryType do
    argument :id, !types.ID
    resolve Resolvers::QueryType::Story
  end

  field :tags, !types[TagType] do
    argument :category_slug, types.String
    argument :limit, types.Int
    argument :ordered, types.Boolean
    argument :with_stories, types.Boolean
    argument :with_recent_stories, types.Boolean
    resolve Resolvers::QueryType::Tags
  end

  field :timeline, TimelineType do
    argument :category_slug, types.String
    argument :cursor, types.Int
    argument :limit, types.Int
    argument :limit, types.Int
    argument :popular, types.Boolean
    argument :publisher_ids, types[types.Int]
    argument :publisher_slug, types.String
    argument :recent, types.Boolean
    argument :tag_slug, types.String
    argument :timezone, types.String
    argument :type, types.String
    argument :with_summary, types.Boolean
    resolve Resolvers::QueryType::Timeline
  end
end
