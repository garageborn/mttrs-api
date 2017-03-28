class CategoryMatcher < ApplicationRecord
  include Concerns::Filterable
  include Concerns::StripAttributes

  belongs_to :publisher
  belongs_to :category

  validates :publisher, :category, presence: true
  validates :url_matcher,
            uniqueness: { case_sensitive: false, scope: :publisher_id },
            allow_blank: true

  strip_attributes :url_matcher, :html_matcher

  scope :order_by_publisher_name, -> { joins(:publisher).order('unaccent(publishers.name) ASC') }
  scope :order_by_category_name, -> { joins(:category).order('unaccent(categories.name) ASC') }
  scope :ordered, -> { order(:order) }
end
