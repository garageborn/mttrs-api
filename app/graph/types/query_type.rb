QueryType = GraphQL::ObjectType.define do
  name 'QueryType'

  field :categories, !types[CategoryType] do
    argument :ordered, types.Boolean
    argument :order_by_name, types.Boolean
    argument :order_by_stories_count, types.Boolean
    argument :with_stories, types.Boolean
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

  field :timeline, !types[TimelineItemType] do
    argument :days, !types.Int
    argument :offset, types.Int
    argument :timezone, types.String
    argument :type, !types.String
    resolve Resolvers::QueryType::Timeline
  end
end
