PublisherIconType = GraphQL::ObjectType.define do
  name 'PublisherIconType'

  field :xsmall, !types.String
  field :small, !types.String
  field :medium, !types.String
end
