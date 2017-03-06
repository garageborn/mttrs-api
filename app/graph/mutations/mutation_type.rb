MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :createLinkAccess, field: CreateLinkAccessMutation.field
  field :createPublisherSuggestion, field: CreatePublisherSuggestionMutation.field
end
