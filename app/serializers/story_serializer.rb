class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :content, :url, :created_at, :updated_at
end
