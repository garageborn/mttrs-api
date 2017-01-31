StoryType = GraphQL::ObjectType.define do
  name 'Story Type'
  description 'Story Type'

  field :id, !types.ID
  field :total_social, !types.Int
  field :created_at, !types.Int
  field :published_at, !types.Int
  field :summary, types.String
  field :headline, types.String
  field :main_category, !CategoryType do
    resolve StoryType.cache.fetch(:main_category) { |obj, _args, _ctx|
      obj.categories.first
    }
  end
  field :main_link, !LinkType do
    argument :publisher_slug, types.String
    resolve StoryType.cache.fetch(:main_link) { |obj, args, _ctx|
      publisher_slug = args['publisher_slug']
      next obj.main_link if publisher_slug.blank?
      obj.main_publisher_link(publisher_slug)
    }
  end
  field :other_links_count, !types.Int do
    resolve StoryType.cache.fetch(:other_links_count) { |obj, args, _ctx|
      obj.other_story_links.size
    }
  end
  field :other_links, types[LinkType] do
    argument :popular, types.Boolean
    argument :publisher_slug, types.String
    resolve StoryType.cache.fetch(:other_links) { |obj, args, _ctx|
      publisher_slug = args['publisher_slug']
      filter = args.to_h.except('publisher_slug')
      next obj.other_links.filter(filter) if publisher_slug.blank?
      obj.links.where.not(id: obj.main_publisher_link(publisher_slug)).filter(filter)
    }
  end
end

GraphqlCache.define(StoryType) do |config|
  config.base_key do |obj, _args, _ctx|
    "#{ Apartment::Tenant.current }/story_type/#{ obj.id }"
  end
end
