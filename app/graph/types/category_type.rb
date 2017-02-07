CategoryType = GraphQL::ObjectType.define do
  name 'Category'

  interfaces [GraphQL::Relay::Node.interface]
  global_id_field :id

  field :id, !types.ID
  field :name, !types.String
  field :slug, !types.String
  field :image_id, !types.String
  field :color, !types.String
end
