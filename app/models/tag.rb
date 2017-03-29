class Tag < ApplicationRecord
  include Concerns::Filterable
  extend FriendlyId

  belongs_to :category
  has_many :link_tags, inverse_of: :tag, dependent: :destroy
  has_many :links, through: :link_tags
  has_many :tag_matchers, inverse_of: :tag, dependent: :destroy

  scope :order_by_category_name, -> { joins(:category).order('unaccent(categories.name) ASC') }
  scope :order_by_name, -> { order(:name) }
  scope :ordered, -> { order(:order) }

  friendly_id :name, use: %i(slugged finders)
end
