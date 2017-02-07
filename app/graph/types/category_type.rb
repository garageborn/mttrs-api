CategoryType = GraphQL::ObjectType.define do
  name 'CategoryType'
  description 'CategoryType'

  field :id, !types.ID
  field :name, !types.String
  field :slug, !types.String
  field :image_id, !types.String
  field :color, !types.String
end
