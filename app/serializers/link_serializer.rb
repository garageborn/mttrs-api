class LinkSerializer < ActiveModel::Serializer
  attributes :id, :title, :url
  has_one :publisher
end
