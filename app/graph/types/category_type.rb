CategoryType = GraphQL::ObjectType.define do
  name 'Category Type'
  description 'Category Type'

  field :id, !types.ID
  field :name, !types.String
end
