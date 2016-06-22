class Link < ActiveRecord::Base
  include Concerns::Filterable
  include Concerns::LinkMissingAttributes
  include Concerns::Searchable
  include Concerns::StripAttributes

  belongs_to :story
  belongs_to :publisher
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :feeds
  has_many :related, through: :story, class_name: 'Link', source: :links
  has_many :social_counters, inverse_of: :link, dependent: :destroy
  has_one :social_counter, -> { order(id: :desc) }

  validates :title, :publisher, :published_at, presence: true
  validates :source_url, :url, presence: true, uniqueness: { case_sensitive: false }
  validates :language, inclusion: { in: Utils::Language::EXISTING_LANGUAGES }, allow_blank: true
  validate :validate_unique_link

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

  before_destroy do
    feeds.clear
    categories.clear
  end

  strip_attributes :title, :description

  class << self
    def parse_date(date)
      return Time.at(date.to_i).utc if date.is_a?(Integer) || date.to_i > 0
      Date.parse(date)
    end
  end

  def uri
    Addressable::URI.parse(url)
  end

  # def related
  #   Story.search(
  #     query: {
  #       more_like_this: {
  #         fields: [:title, :description],
  #         like: [{ _id: id }],
  #         min_term_freq: 1
  #       }
  #     }
  #   ).results
  # end

  private

  def validate_unique_link
    return if publisher.blank?
    other_link = publisher.links.where(title: title).where.not(id: id).first
    return if other_link.blank?
    errors.add(:url, :invalid) if other_link.uri.path == uri.path
  end
end
