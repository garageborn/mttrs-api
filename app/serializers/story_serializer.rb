class StorySerializer < ActiveModel::Serializer
  attributes :id, :total_social, :created_at, :updated_at
  has_one :main_link
  has_many :other_links
end
