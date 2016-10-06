class StorySerializer < ActiveModel::Serializer
  attributes :id, :total_social
  has_one :main_link
  has_many :other_links
end
