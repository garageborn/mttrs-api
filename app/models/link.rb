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
  has_many :social_counters, inverse_of: :link, dependent: :destroy
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

  after_commit :instrument_commit
  strip_attributes :title, :description
  serialize :html, Utils::BinaryStringSerializer

  def uri
    Addressable::URI.parse(url)
  end

  private

  def instrument_commit
    ActiveSupport::Notifications.instrument('link.committed', self)
  end
end
