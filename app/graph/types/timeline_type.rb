TimelineType = GraphQL::ObjectType.define do
  name 'TimelineType'

  field :date, types.Int
  field :stories, types[StoryType] do
    resolve Resolvers::TimelineType::Stories
  end
end
