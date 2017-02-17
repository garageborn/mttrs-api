TimelineType = GraphQL::ObjectType.define do
  name 'TimelineType'

  # argument :limit, types.Int
  # argument :category_slug, types.String
  # argument :limit, types.Int
  # argument :popular, types.Boolean
  # argument :publisher_slug, types.String
  # argument :recent, types.Boolean

  field :date, types.Int
  field :stories, types[StoryType] do
    resolve Resolvers::TimelineType::Stories
  end
end
