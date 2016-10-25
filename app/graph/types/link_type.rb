LinkType = GraphQL::ObjectType.define do
  name 'Link Type'
  description 'Link Type'

  field :id, !types.ID
  field :title, !types.String
  field :url, !types.String
  field :created_at, !types.Int
  field :publisher, !PublisherType
  field :categories, types[CategoryType]
  field :image_source_url, types.String
end
