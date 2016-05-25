class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :content, :url, :image_source_url, :publisher,
             :created_at, :updated_at
end
