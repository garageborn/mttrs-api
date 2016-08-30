class Namespace < ApplicationRecord
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :feeds
  has_and_belongs_to_many :links
end
