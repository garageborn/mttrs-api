class TagMatcher < ApplicationRecord
  include Concerns::Filterable
  include Concerns::StripAttributes
  extend Memoist

  belongs_to :tag
  belongs_to :publisher
  has_one :category, through: :tag

  validates :tag, presence: true

  strip_attributes :url_matcher, :html_matcher

  scope :category_slug, ->(slug) { joins(:category).where(categories: { slug: slug }) }
  scope :order_by_category_name, -> { joins(:category).order('categories.name ASC') }
  scope :order_by_publisher_name, -> { joins(:publisher).order('publishers.name ASC') }
  scope :order_by_tag_name, -> { joins(:tag).order('tags.name ASC') }
  scope :publisher_slug,->(slug) { joins(:publisher).where(publishers: { slug: slug }) }
  scope :tag_slug, ->(slug) { joins(:tag).where(tags: { slug: slug }) }

  def match?(link)
    return false if link_matcher.blank?
    match_category?(link) && link_matcher.match?(link)
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

  def match_category?(link)
    link.category == category
  end

  memoize :link_matcher, :match?, :match_category?
end
