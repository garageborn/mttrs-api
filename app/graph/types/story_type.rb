StoryType = GraphQL::ObjectType.define do
  name 'StoryType'

  field :id, !types.ID
  field :total_social, !types.Int
  field :created_at, !types.Int
  field :published_at, !types.Int
  field :summary, types.String
  field :headline, types.String
  field :main_category, !CategoryType
  field :main_link, !LinkType do
    argument :publisher_slug, types.String
    resolve Resolvers::StoryType::MainLink
  end
  field :other_links_count, !types.Int do
    resolve ->(obj, _args, _ctx) { obj.other_story_links.size }
  end
  field :other_links, types[LinkType] do
    argument :popular, types.Boolean
    argument :publisher_slug, types.String
    resolve Resolvers::StoryType::OtherLinks
  end
end
