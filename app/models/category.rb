class Category < ApplicationRecord
  include Concerns::Filterable
  extend FriendlyId

  has_many :category_links, inverse_of: :category, dependent: :destroy
  has_many :category_matchers, inverse_of: :category, dependent: :destroy
  has_many :links, through: :category_links
  has_many :stories, -> { distinct }, through: :links

  scope :order_by_name, -> { order(:name) }
  scope :ordered, -> { order(:order) }
  scope :with_stories, -> { joins(:stories).group('categories.id') }

  friendly_id :name, use: %i(slugged finders)
end
