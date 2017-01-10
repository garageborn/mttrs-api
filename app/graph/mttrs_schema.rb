MttrsSchema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
  max_depth 8
end
