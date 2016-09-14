class Category < ApplicationRecord
  include Concerns::Filterable
  extend FriendlyId

  has_many :category_feeds, inverse_of: :category, dependent: :destroy
  has_many :category_links, inverse_of: :category, dependent: :destroy
  has_many :category_matchers, inverse_of: :category, dependent: :destroy
  has_many :feeds, through: :category_feeds
  has_many :links, through: :category_links

  scope :order_by_name, -> { order(:name) }

  friendly_id :name, use: %i(slugged finders)
end
