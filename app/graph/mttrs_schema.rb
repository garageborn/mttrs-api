MttrsSchema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
  max_depth 8

  id_from_object ->(object, type_definition, query_ctx) {
    p '-----------id_from_object'
    GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.id)
  }

  object_from_id ->(id, query_ctx) {
    p '-------------------object_from_id'
    type_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)
    # Now, based on `type_name` and `id`
    # find an object in your application
    # ....
  }

  resolve_type lambda { |object, ctx|
    p '-------------------resolve_type'
  }
end
