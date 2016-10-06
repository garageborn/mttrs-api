class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :image_source_url, :total_social, :published_at

  has_many :links
  has_one :main_link
  has_many :other_links
end
