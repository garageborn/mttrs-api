PublisherSuggestionType = GraphQL::ObjectType.define do
  name 'PublisherSuggestionType'

  field :id, !types.ID
  field :name, !types.String
  field :count, !types.Int
end
