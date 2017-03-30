TagType = GraphQL::ObjectType.define do
  name 'TagType'

  field :id, !types.ID
  field :category, !CategoryType
  field :name, !types.String
  field :slug, !types.String
end
