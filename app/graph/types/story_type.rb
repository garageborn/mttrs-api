StoryType = GraphQL::ObjectType.define do
  name 'Story Type'
  description 'Story Type'

  field :id, !types.ID
  field :total_social, !types.Int
  field :created_at, !types.Int
  field :main_category, !CategoryType do
    resolve -> (obj, _args, _ctx) { obj.categories.first }
  end
  field :main_link, !LinkType do
    argument :publisher_slug, types.String
    resolve -> (obj, args, _ctx) {
      publisher_slug = args['publisher_slug']
      return obj.main_link if publisher_slug.blank?
      filter = args.to_h.except('publisher_slug')
      obj.links.publisher_slug(publisher_slug).popular.filter(filter).first
    }
  end
  field :other_links, types[LinkType] do
    argument :popular, types.Boolean
    argument :publisher_slug, types.String
    resolve -> (obj, args, _ctx) {
      publisher_slug = args['publisher_slug']
      return obj.other_links if publisher_slug.blank?
      filter = args.to_h.except('publisher_slug')
      main_link = obj.links.publisher_slug(publisher_slug).popular.filter(filter).first
      obj.links.where.not(id: main_link).filter(filter)
    }
  end
end
