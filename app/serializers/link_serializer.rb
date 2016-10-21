class LinkSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :image_source_url, :published_at, :total_social
  has_one :publisher
  has_many :categories
end
