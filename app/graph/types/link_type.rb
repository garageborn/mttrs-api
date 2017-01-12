LinkType = GraphQL::ObjectType.define do
  name 'Link Type'
  description 'Link Type'

  field :categories, types[CategoryType]
  field :created_at, !types.Int
  field :id, !types.ID
  field :image_source_url, types.String
  field :publisher, !PublisherType
  field :story, !types[StoryType]
  field :title, !types.String
  field :total_social, !types.Int
  field :url, !types.String
  field :slug, !types.String
end
