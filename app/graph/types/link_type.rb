LinkType = GraphQL::ObjectType.define do
  name 'Link Type'
  description 'Link Type'

  field :categories, types[CategoryType]
  field :created_at, !types.Int
  field :id, !types.ID
  field :image_source_url, types.String
  field :publisher, !PublisherType do
    resolve LinkType.cache.fetch(:publisher) { |obj, _args, _ctx|
      obj.publisher
    }
  end
  field :story, !StoryType
  field :title, !types.String
  field :total_social, !types.Int
  field :url, !types.String
  field :slug, !types.String
end

GraphqlCache.define(LinkType) do |config|
  config.base_key do |obj, _args, _ctx|
    "link_type/#{ obj.id }"
  end
end
