class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :image_source_url, :publisher, :total_social,
             :created_at, :updated_at, :published_at
end
