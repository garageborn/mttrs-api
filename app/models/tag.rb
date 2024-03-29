class Tag < ApplicationRecord
  include Concerns::Filterable
  extend FriendlyId

  belongs_to :category
  has_many :link_tags, inverse_of: :tag, dependent: :destroy
  has_many :tag_matchers, inverse_of: :tag, dependent: :destroy

  has_many :links, through: :link_tags
  has_many :stories, through: :links

  scope :category_slug, ->(slug) { joins(:category).where(categories: { slug: slug }) }
  scope :order_by_category_name, -> { joins(:category).order('unaccent(categories.name) ASC') }
  scope :order_by_name, -> { order(:name) }
  scope :ordered, -> { order(:order) }
  scope :with_stories, -> { joins(:stories).group('tags.id') }
  scope :with_recent_stories, lambda {
    joins(:stories).where(stories: { published_at: 7.days.ago..Float::INFINITY })
                   .group('tags.id')
  }

  friendly_id :name, use: %i[slugged finders]
end
