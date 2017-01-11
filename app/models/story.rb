class Story < ApplicationRecord
  include Concerns::Filterable
  include Concerns::ParseDate
  extend Memoist

  has_many :categories, -> { distinct }, through: :links
  has_many :links, through: :story_links
  has_many :links_accesses, through: :links, source: :accesses
  has_many :other_links, through: :other_story_links, source: :link
  has_many :other_story_links, -> { where(main: false) }, class_name: 'StoryLink'
  has_many :publishers, -> { distinct }, through: :links
  has_many :story_links, inverse_of: :story, dependent: :destroy
  has_one :main_link, through: :main_story_link, source: :link
  has_one :main_story_link, -> { where(main: true) }, class_name: 'StoryLink'

  scope :category_slug, lambda { |slug|
    joins(:categories).group(:id).where(categories: { slug: slug })
  }
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
    where(published_at: parse_date(date)..Float::INFINITY)
  }
  scope :publisher_slug, lambda { |slug|
    joins(:publishers).group(:id).where(publishers: { slug: slug })
  }
  scope :recent, -> { order('stories.published_at DESC') }
  scope :today, -> { published_at(Time.zone.now) }
  scope :yesterday, -> { published_at(1.day.ago) }

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

  memoize :main_publisher_link
end
