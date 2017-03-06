PublisherType = GraphQL::ObjectType.define do
  name 'PublisherType'

  field :id, !types.ID
  field :name, !types.String
  field :display_name, types.String
  field :slug, !types.String
  field :icon_id, !types.String
  field :today_stories_count, !types.Int do
    resolve Resolvers::PublisherType::TodayStoriesCount
  end
end
