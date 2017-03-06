CreatePublisherSuggestionMutation = GraphQL::Relay::Mutation.define do
  name 'CreatePublisherSuggestionMutation'

  input_field :name, !types.String
  return_field :publisher_suggestion, PublisherSuggestionType

  resolve lambda { |_obj, inputs, _ctx|
    params = { publisher_suggestion: { name: inputs[:name] } }
    _result, op = PublisherSuggestion::IncrementCount.run(params)
    { publisher_suggestion: op.model }
  }
end
