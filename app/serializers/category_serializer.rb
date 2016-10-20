class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :icon_id, :color, :order, :created_at, :updated_at
end
