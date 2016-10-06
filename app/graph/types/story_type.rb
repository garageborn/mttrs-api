StoryType = GraphQL::ObjectType.define do
  name 'Story Type'
  description 'Story Type'

  field :id, !types.ID
  field :total_social, !types.Int
  field :created_at, !types.Int
  field :main_link, !LinkType
  field :other_links, types[LinkType]
end
