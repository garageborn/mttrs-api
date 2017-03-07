class Link < ApplicationRecord
  include Concerns::Filterable
  include Concerns::LinkMissingAttributes
  include Concerns::TenantLink
  include Concerns::Searchable
  include Concerns::StripAttributes
  include Concerns::ParseDate
  include Concerns::TrackAccess
  extend FriendlyId
  extend Memoist

  belongs_to :publisher
  has_one :category, through: :category_link
  has_one :category_link, inverse_of: :link, dependent: :destroy
  has_many :link_urls, inverse_of: :link, dependent: :destroy
  has_one :link_url, -> { order(id: :desc) }
  has_many :social_counters, inverse_of: :link, dependent: :destroy
  has_one :story_link, inverse_of: :link, dependent: :destroy
  has_one :story, through: :story_link
  has_one :social_counter, -> { order(id: :desc) }

  scope :category_slug, ->(slug) { joins(:category).where(categories: { slug: slug }) }
  scope :last_month, -> { published_since(1.month.ago) }
  scope :last_week, -> { published_since(1.week.ago) }
  scope :order_by_url, -> { joins(:link_url).order('link_urls.url') }
  scope :popular, -> { order(total_social: :desc) }
  scope :published_at, lambda { |date|
    date = parse_date(date)
    published_between(date.at_beginning_of_day, date.end_of_day)
  }
  scope :published_between, lambda { |start_at, end_at|
    where(published_at: parse_date(start_at)..parse_date(end_at))
  }
  scope :published_since, lambda { |date|
    where('links.published_at >= ?', parse_date(date))
  }
  scope :published_until, lambda { |date|
    where('links.published_at <= ?', parse_date(date))
  }
  scope :publisher_slug, ->(slug) { joins(:publisher).where(publishers: { slug: slug }) }
  scope :random, -> { order('RANDOM()') }
  scope :recent, -> { order(published_at: :desc) }
  scope :today, -> { published_at(Time.zone.now) }
  scope :uncategorized, -> { left_outer_joins(:category_link).where(category_links: { id: nil }) }
  scope :yesterday, -> { published_at(1.day.ago) }

  strip_attributes :content, :description, :title
  serialize :html, ::Utils::BinaryStringSerializer
  serialize :content, ::Utils::BinaryStringSerializer
  friendly_id :title, use: %i(slugged finders)

  def self.find_by_url(url)
    joins(:link_urls).find_by(link_urls: { url: url })
  end

  def uri
    return if link_url.blank?
    Addressable::URI.parse(link_url.url)
  end

  def url
    return if link_url.blank?
    uri.to_s
  end

  def urls
    link_urls.map(&:url)
  end

  def urls=(value)
    value.each do |url|
      next if urls.include?(url)
      link_urls.build(url: url)
    end
  end

  def page
    return if html.blank?
    Nokogiri::HTML(html)
  end

  memoize :page
end
