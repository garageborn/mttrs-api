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
    argument :order_by_name, types.Boolean
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

  field :timeline, !types[TimelineItemType] do
    argument :days, !types.Int
    argument :offset, types.Int
    resolve -> (_obj, args, _ctx) do
      start_at = args['offset'].to_i
      end_at = start_at + args['days'].to_i

      (start_at...end_at).map do |day|
        OpenStruct.new(date: day.days.ago.utc.to_i)
      end
    end
  end
end
