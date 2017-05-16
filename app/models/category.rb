class Category < ApplicationRecord
  include Concerns::Filterable
  extend FriendlyId

  has_many :category_links, inverse_of: :category, dependent: :destroy
  has_many :category_matchers, inverse_of: :category, dependent: :destroy
  has_many :links, through: :category_links
  has_many :publishers, -> { distinct }, through: :links
  has_many :stories, -> { distinct }, through: :links
  has_many :tags, inverse_of: :category, dependent: :destroy

  scope :order_by_name, -> { order(:name) }
  scope :ordered, -> { order(:order) }
  scope :tag_slug, ->(slug) { joins(:tags).where(tags: { slug: slug }) }
  scope :publisher_ids, lambda { |ids|
    joins(:publishers).where(publishers: { id: ids }).group('categories.id')
  }
  scope :with_stories, -> { joins(:stories).group('categories.id') }
  scope :with_tags, -> { joins(:tags).group('categories.id') }

  friendly_id :name, use: %i(slugged finders)
end
