QueryType = GraphQL::ObjectType.define do
  name 'Query Type'
  description 'Query Type'

  field :categories, !types[CategoryType] do
    resolve -> (obj, args, ctx) { Category.all }
  end

  field :publishers, !types[PublisherType] do
    resolve -> (obj, args, ctx) { Publisher.all }
  end

  field :publisher, PublisherType do
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { Publisher.find(args['id']) }
  end
end
