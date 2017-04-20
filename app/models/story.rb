class Story < ApplicationRecord
  include Concerns::Filterable
  include Concerns::ParseDate
  include Concerns::TrackAccess
  extend Memoist

  belongs_to :category
  has_many :blocked_story_links, inverse_of: :story, dependent: :destroy
  has_many :blocked_links, through: :blocked_story_links, source: :link, class_name: 'Link'
  has_many :link_tags, through: :links
  has_many :amp_links, through: :links
  has_many :links, through: :story_links
  has_many :links_accesses, through: :links, source: :accesses
  has_many :other_links, through: :other_story_links, source: :link
  has_many :other_story_links, -> { where(main: false) }, class_name: 'StoryLink'
  has_many :publishers, -> { distinct }, through: :links
  has_many :story_links, inverse_of: :story, dependent: :destroy
  has_many :tags, -> { distinct }, through: :link_tags
  has_one :main_link, through: :main_story_link, source: :link
  has_one :main_story_link, -> { where(main: true) }, class_name: 'StoryLink'

  scope :category_slug, ->(slug) { joins(:category).where(categories: { slug: slug }) }
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
  scope :published_since, ->(date) { where(published_at: parse_date(date)..Float::INFINITY) }
  scope :published_until, ->(date) { where('stories.published_at < ?', parse_date(date)) }
  scope :publisher_slug, lambda { |slug|
    joins(:publishers).group(:id).where(publishers: { slug: slug })
  }
  scope :recent, -> { order('stories.published_at DESC') }
  scope :tag_slug, ->(slug) { joins(:tags).where(tags: { slug: slug }).group('stories.id') }
  scope :today, -> { published_at(Time.zone.now) }
  scope :yesterday, -> { published_at(1.day.ago) }
  scope :with_amp, lambda {
    joins(:amp_links).where(amp_links: { status: :success }).group('stories.id')
  }
  scope :with_summary, -> { where.not(summary: nil).where.not(summary: '') }

  def total_facebook
    links.map { |link| link.social_counter.try(:facebook).to_i }.sum
  end

  def total_linkedin
    links.map { |link| link.social_counter.try(:linkedin).to_i }.sum
  end

  def total_twitter
    links.map { |link| link.social_counter.try(:twitter).to_i }.sum
  end

  def total_pinterest
    links.map { |link| link.social_counter.try(:pinterest).to_i }.sum
  end

  def total_google_plus
    links.map { |link| link.social_counter.try(:google_plus).to_i }.sum
  end

  def main_publisher_link(slug)
    links.publisher_slug(slug).popular.first
  end

  def main_image_source_url
    image_source_url = main_link.try(:image_source_url)
    return image_source_url if image_source_url.present?
    links.popular.pluck(:image_source_url).compact.uniq.select(&:present?).first
  end

  memoize :main_publisher_link
end
