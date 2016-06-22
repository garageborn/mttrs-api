class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :image_source_url, :total_social, :published_at
end
