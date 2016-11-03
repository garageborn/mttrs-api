TimelineItemType = GraphQL::ObjectType.define do
  name 'Timeline Item Type'
  description 'Timeline Item Type'

  field :date, !types.Int
  field :stories, !types[StoryType] do
    argument :limit, types.Int
    argument :category_slug, types.String
    argument :limit, types.Int
    argument :popular, types.Boolean
    argument :publisher_slug, types.String
    argument :recent, types.Boolean
    resolve -> (obj, args, _ctx) {
      Story.filter(args).published_at(obj.date)
    }
  end
end
