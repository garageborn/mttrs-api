class CategoryMatcher < ApplicationRecord
  include Concerns::Filterable
  include Concerns::StripAttributes
  extend Memoist

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

  def match?(link)
    return false if link_matcher.blank?
    link_matcher.match?(link)
  end

  private

  def link_matcher
    return if url_matcher.blank? || html_matcher.blank?
    ::LinkMatcher.new(
      url_matcher: url_matcher,
      html_matcher: html_matcher,
      html_matcher_selector: html_matcher_selector
    )
  end

  memoize :link_matcher, :match?
end
