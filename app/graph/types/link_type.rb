LinkType = GraphQL::ObjectType.define do
  name 'LinkType'

  field :categories, types[CategoryType]
  field :created_at, !types.Int
  field :id, !types.ID
  field :image_source_url, types.String
  field :publisher, !PublisherType
  field :story, !StoryType
  field :title, !types.String
  field :total_social, !types.Int
  field :url, !types.String
  field :slug, !types.String
  field :html, types.String do
    resolve ->(obj, _args, _ctx) { obj.html.to_s.force_encoding('UTF-8') }
  end
end
