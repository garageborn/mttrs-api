TimelineItemType = GraphQL::ObjectType.define do
  name 'TimelineItemType'

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
    resolve Resolvers::TimelineItemType::Stories
  end
end
