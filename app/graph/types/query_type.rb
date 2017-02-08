require Rails.root.join('lib', 'graphql_cache')

QueryType = GraphQL::ObjectType.define do
  name 'QueryType'

  field :categories, !types[CategoryType] do
    argument :ordered, types.Boolean
    argument :order_by_name, types.Boolean
    argument :order_by_stories_count, types.Boolean
    argument :with_stories, types.Boolean
    resolve lambda { |_obj, args, ctx|
      GraphqlCache.cache_for(:categories, ctx).expires_in 15.minutes
      Category.filter(args)
    }
  end

  field :category, CategoryType do
    argument :slug, !types.String
    resolve lambda { |_obj, args, ctx|
      GraphqlCache.cache_for(:category, ctx).expires_in 15.minutes
      Category.find(args['slug'])
    }
  end

  field :link, LinkType do
    argument :slug, !types.String
    resolve lambda { |_obj, args, ctx|
      GraphqlCache.cache_for(:link, ctx).expires_in 15.minutes
      Link.find(args['slug'])
    }
  end

  field :publishers, !types[PublisherType] do
    argument :limit, types.Int
    argument :order_by_name, types.Boolean
    argument :with_stories, types.Boolean
    resolve lambda { |_obj, args, ctx|
      GraphqlCache.cache_for(:publishers, ctx).expires_in 15.minutes
      Publisher.filter(args)
    }
  end

  field :publisher, PublisherType do
    argument :slug, !types.String
    resolve lambda { |_obj, args, ctx|
      GraphqlCache.cache_for(:publisher, ctx).expires_in 15.minutes
      Publisher.find(args['slug'])
    }
  end

  field :story, StoryType do
    argument :id, !types.ID
    resolve lambda { |_obj, args, ctx|
      GraphqlCache.cache_for(:story, ctx).expires_in 15.minutes
      Story.find(args['id'])
    }
  end

  field :timeline, !types[TimelineItemType] do
    argument :days, !types.Int
    argument :offset, types.Int
    argument :timezone, types.String
    argument :type, !types.String

    resolve lambda { |_obj, args, ctx|
      GraphqlCache.cache_for(:timeline, ctx).expires_in 15.minutes
      start_at = args['offset'].to_i
      end_at = start_at + args['days'].to_i
      timezone = args['timezone'] || 'UTC'

      (start_at...end_at).map do |day|
        date = Time.use_zone(timezone) { day.days.ago.at_beginning_of_day.to_i }
        OpenStruct.new(date: date, timezone: timezone, type: args['type'])
      end
    }
  end
end
