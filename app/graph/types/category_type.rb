CategoryType = GraphQL::ObjectType.define do
  name 'CategoryType'

  field :id, !types.ID
  field :name, !types.String
  field :slug, !types.String
  field :color, !types.String
  field :tags, types[TagType]
  field :tags_count, !types.Int do
    argument :limit, types.Int
    argument :ordered, types.Boolean
    argument :with_stories, types.Boolean
    argument :with_recent_stories, types.Boolean
    resolve Resolvers::CategoryType::TagsCount
  end
end
