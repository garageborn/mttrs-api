class TagMatcher < ApplicationRecord
  include Concerns::Filterable
  include Concerns::StripAttributes
  include Concerns::LinkMatcher

  belongs_to :tag
  has_one :category, through: :tag

  validates :tag, presence: true

  strip_attributes :url_matcher,  :html_matcher

  scope :order_by_category_name, -> { joins(:category).order('unaccent(categories.name) ASC') }
  scope :order_by_tag_name, -> { joins(:tag).order('unaccent(tags.name) ASC') }
end
