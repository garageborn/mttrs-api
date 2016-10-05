class LinkSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :created_at
  has_one :publisher
  has_many :categories
end
