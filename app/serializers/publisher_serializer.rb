class PublisherSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :created_at, :updated_at
end