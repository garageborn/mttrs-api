LinkType = GraphQL::ObjectType.define do
  name 'LinkType'

  field :category, CategoryType
  field :created_at, !types.Int
  field :id, !types.ID
  field :image, !LinkImageType do
    argument :dpr, types.Int
    resolve Resolvers::LinkType::Image
  end
  field :image_source_url, types.String do
    resolve Resolvers::LinkType::ImageSourceUrl
  end
  field :publisher, !PublisherType
  field :story, !StoryType
  field :title, !types.String
  field :tags, types[TagType]
  field :total_social, !types.Int
  field :url, !types.String
  field :amp_url, types.String
  field :slug, !types.String
  field :social_counter, SocialCounterType
end
