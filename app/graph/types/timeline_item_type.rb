TimelineItemType = GraphQL::ObjectType.define do
  name 'Timeline Item Type'
  description 'Timeline Item Type'

  field :date, !types.Int
  field :timezone, !types.String
  field :stories, !types[StoryType] do
    argument :limit, types.Int
    argument :category_slug, types.String
    argument :limit, types.Int
    argument :popular, types.Boolean
    argument :publisher_slug, types.String
    argument :recent, types.Boolean
    resolve -> (obj, args, _ctx) {
      start_at = Time.use_zone(obj.timezone) { Time.zone.at(obj.date).at_beginning_of_day }
      end_at = Time.use_zone(obj.timezone) { Time.zone.at(obj.date).end_of_day }
      Story.filter(args).published_between(start_at, end_at)
    }
  end
end
