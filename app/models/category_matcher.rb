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

  strip_attributes :url_matcher

  scope :order_by_publisher_name, -> { joins(:publisher).order('unaccent(publishers.name) ASC') }
  scope :ordered, -> { order(:order) }

  def match?(link)
    return false unless link.available_on_current_tenant?
    match_url?(link) || match_html?(link)
  end

  def method
    html_matcher_selector.start_with?('//') ? :xpath : :css
  end

  def url_matcher_regexp
    Regexp.new(url_matcher, Regexp::IGNORECASE)
  end

  def html_matcher_regexp
    Regexp.new(html_matcher, Regexp::IGNORECASE)
  end

  private

  def match_url?(link)
    return false if url_matcher.blank?
    link.url.match(url_matcher_regexp).present?
  end

  def match_html?(link)
    return false if link.page.blank?
    return false if html_matcher.blank? || html_matcher_selector.blank?

    selector = link.page.send(method, html_matcher_selector)
    text = Utils::StripAttributes.run(selector.text)
    return if text.blank?
    text.match(html_matcher_regexp).present?
  end

  memoize :match?, :match_url?
end
