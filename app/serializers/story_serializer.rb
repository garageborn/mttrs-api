class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :content, :url, :image, :publisher, :created_at, :updated_at
end
