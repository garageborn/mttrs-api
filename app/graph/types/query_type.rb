QueryType = GraphQL::ObjectType.define do
  name 'Query Type'
  description 'Query Type'

  field :categories, !types[CategoryType] do
    argument :order_by_name, types.Boolean
    argument :order_by_stories_count, types.Boolean
    resolve -> (_obj, args, _ctx) { Category.filter(args) }
  end

  field :publishers, !types[PublisherType] do
    argument :limit, types.Int
    resolve -> (_obj, args, _ctx) { Publisher.filter(args) }
  end

  field :publisher, PublisherType do
    argument :id, !types.ID
    resolve -> (_obj, args, _ctx) { Publisher.find(args['id']) }
  end

  field :story, StoryType do
    argument :id, !types.ID
    resolve -> (_obj, args, _ctx) { Story.find(args['id']) }
  end

  field :stories, !types[StoryType] do
    argument :category_slug, types.String
    argument :last_month, types.Boolean
    argument :last_week, types.Boolean
    argument :limit, types.Int
    argument :popular, types.Boolean
    argument :published_at, types.Int
    argument :publisher_slug, types.String
    argument :recent, types.Boolean
    argument :today, types.Boolean
    argument :yesterday, types.Boolean
    resolve -> (_obj, args, _ctx) { Story.filter(args) }
  end
end
