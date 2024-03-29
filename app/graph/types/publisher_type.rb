PublisherType = GraphQL::ObjectType.define do
  name 'PublisherType'

  field :id, !types.ID
  field :name, !types.String
  field :display_name, types.String
  field :restrict_content, !types.Boolean
  field :slug, !types.String
  field :icon, !PublisherIconType do
    argument :dpr, types.Int
    resolve Resolvers::PublisherType::Icon
  end
  field :icon_id, types.String
  field :today_stories_count, !types.Int do
    resolve Resolvers::PublisherType::TodayStoriesCount
  end
end
