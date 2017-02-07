PublisherType = GraphQL::ObjectType.define do
  name 'Publisher'

  field :id, !types.ID
  field :name, !types.String
  field :slug, !types.String
  field :icon_id, !types.String
end
