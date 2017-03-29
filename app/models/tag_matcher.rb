class TagMatcher < ApplicationRecord
  include Concerns::Filterable
  include Concerns::StripAttributes
  extend Memoist

  belongs_to :tag
  belongs_to :publisher
  has_one :category, through: :tag

  validates :tag, presence: true

  strip_attributes :url_matcher,  :html_matcher

  scope :order_by_category_name, -> { joins(:category).order('unaccent(categories.name) ASC') }
  scope :order_by_tag_name, -> { joins(:tag).order('unaccent(tags.name) ASC') }
  scope :order_by_publisher_name, -> { joins(:publisher).order('unaccent(publishers.name) ASC') }

  def match?(link)
    return false if link_matcher.blank?
    link_matcher.match?(link)
  end

  private

  def link_matcher
    return if url_matcher.blank? && html_matcher.blank?
    ::LinkMatcher.new(
      url_matcher: url_matcher,
      html_matcher: html_matcher,
      html_matcher_selector: html_matcher_selector
    )
  end

  memoize :link_matcher, :match?
end
