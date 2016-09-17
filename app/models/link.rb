class Link < ApplicationRecord
  include Concerns::Filterable
  include Concerns::LinkMissingAttributes
  include Concerns::Searchable
  include Concerns::StripAttributes
  include Concerns::ParseDate

  belongs_to :publisher
  has_many :categories, through: :category_links
  has_many :category_links, inverse_of: :link, dependent: :destroy
  has_many :feed_links, inverse_of: :link, dependent: :destroy
  has_many :feeds, through: :feed_links
  has_many :link_urls, inverse_of: :link, dependent: :destroy
  has_many :social_counters, inverse_of: :link, dependent: :destroy
  has_one :story_link, inverse_of: :link, dependent: :destroy
  has_one :story, through: :story_link
  has_one :social_counter, -> { order(id: :desc) }

  scope :category_slug, -> (slug) { joins(:categories).where(categories: { slug: slug }) }
  scope :last_month, -> { published_since(1.month.ago) }
  scope :last_week, -> { published_since(1.week.ago) }
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
  scope :publisher_slug, -> (slug) { joins(:publisher).where(publishers: { slug: slug }) }
  scope :recent, -> { order(published_at: :desc) }
  scope :today, -> { published_at(Time.zone.now) }
  scope :yesterday, -> { published_at(1.day.ago) }

  strip_attributes :title, :description
  serialize :html, Utils::BinaryStringSerializer

  def self.find_by_url(url)
    joins(:link_urls).find_by(link_urls: { url: url })
  end

  def uri
    return if link_urls.blank?
    Addressable::URI.parse(link_urls.last.url)
  end

  def url
    return if uri.blank?
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

  def belongs_to_current_tenant?
    belongs_to_tenant?(Apartment::Tenant.current)
  end

  def belongs_to_tenant?(tenant_name)
    return if new_record?

    Apartment::Tenant.switch(tenant_name) do
      CategoryLink.where(link_id: id).exists?
    end
  end
end
