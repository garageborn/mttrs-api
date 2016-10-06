CategoryType = GraphQL::ObjectType.define do
  name 'Category Type'
  description 'Category Type'

  field :id, !types.ID
  field :name, !types.String
  field :slug, !types.String
  field :icon_id, types.String
  field :color, types.String
end
