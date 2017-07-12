class Link < ApplicationRecord
  include Concerns::Filterable
  include Concerns::LinkMissingAttributes
  include Concerns::TenantLink
  include Concerns::Searchable
  include Concerns::Similar
  include Concerns::StripAttributes
  include Concerns::ParseDate
  include Concerns::TrackAccess
  extend FriendlyId
  extend Memoist

  belongs_to :publisher
  has_many :blocked_story_links, inverse_of: :link, dependent: :destroy
  has_many :link_tags, inverse_of: :link, dependent: :destroy
  has_many :link_urls, inverse_of: :link, dependent: :destroy
  has_many :notifications, as: :notificable, dependent: :destroy
  has_many :social_counters, inverse_of: :link, dependent: :destroy
  has_one :amp_link, inverse_of: :link, dependent: :destroy
  has_one :category_link, inverse_of: :link, dependent: :destroy
  has_one :link_url, -> { order(id: :asc) }
  has_one :social_counter, -> { order(id: :desc) }
  has_one :story_link, inverse_of: :link, dependent: :destroy

  has_many :blocked_stories, through: :blocked_story_links, source: :story, class_name: 'Story'
  has_many :blocked_links, through: :blocked_stories, source: :links, class_name: 'Link'
  has_many :tags, through: :link_tags
  has_one :category, through: :category_link
  has_one :story, through: :story_link

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
  scope :publisher_ids, ->(ids) { joins(:publisher).where(publishers: { id: ids }) }
  scope :publisher_slug, ->(slug) { joins(:publisher).where(publishers: { slug: slug }) }
  scope :random, -> { order('RANDOM()') }
  scope :recent, -> { order(published_at: :desc) }
  scope :tag_slug, ->(slug) { joins(:tags).where(tags: { slug: slug }) }
  scope :today, -> { published_at(Time.zone.now) }
  scope :uncategorized, -> { left_outer_joins(:category_link).where(category_links: { id: nil }) }
  scope :untagged, -> { left_outer_joins(:link_tags).where(link_tags: { id: nil }) }
  scope :with_amp, -> { joins(:amp_link).where(amp_links: { status: :success }) }
  scope :without_tag, lambda { |tag_id|
    scopped = left_outer_joins(:link_tags)
    scopped.where(link_tags: { id: nil }).or(scopped.where.not(link_tags: { id: tag_id }))
  }
  scope :unrestrict_content, -> { joins(:publisher).where(publishers: { restrict_content: false }) }
  scope :yesterday, -> { published_at(1.day.ago) }

  has_attached_file :html
  has_attached_file :image,
    styles: { thumb: '120x95', thumb_2x: '240x190' },
    processors: %i[thumbnail paperclip_optimizer]

  validates_attachment_content_type :html, content_type: %w[text/html text/plain application/xhtml+xml]
  strip_attributes :description, :title
  friendly_id :title, use: %i[slugged finders]

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

  def amp_url
    return unless amp_link.try(:success?)
    amp_link.url
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
    file = Paperclip.io_adapters.for(html).read
    return if file.blank?
    Nokogiri::HTML(file)
  end

  def image_source_url=(url_value)
    return if url_value == read_attribute(:image_source_url)
    self.image = nil
    write_attribute(:image_source_url, url_value)
  end

  memoize :page
end
