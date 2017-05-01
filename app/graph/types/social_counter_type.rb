SocialCounterType = GraphQL::ObjectType.define do
  name 'SocialCounterType'

  field :facebook, !types.Int
  field :google_plus, !types.Int
  field :linkedin, !types.Int
  field :pinterest, !types.Int
  field :total, !types.Int
  field :twitter, !types.Int
end
