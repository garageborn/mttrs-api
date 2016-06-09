class Story < ActiveRecord::Base
  include Concerns::Filterable
  include Concerns::StoryMissingAttributes

  belongs_to :publisher
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :feeds
  has_many :social_counters, inverse_of: :story, dependent: :destroy
  has_one :social_counter, -> { order(id: :desc) }

  validates :title, :publisher, :published_at, presence: true
  validates :source_url, :url, presence: true, uniqueness: { case_sensitive: false }
  validate :validate_unique_story

  scope :category_slug, -> (slug) { joins(:categories).where(categories: { slug: slug }) }
  scope :published_at, -> (date) { published_between(date.at_beginning_of_day, date.end_of_day) }
  scope :published_between, -> (start_at, end_at) { where(published_at: start_at..end_at) }
  scope :published_since, -> (date) { where('stories.published_at >= ?', date) }
  scope :published_until, -> (date) { where('stories.published_at <= ?', date) }
  scope :last_month, -> { published_since(1.month.ago) }
  scope :last_week, -> { published_since(1.week.ago) }
  scope :recent, -> { order(published_at: :desc) }
  scope :today, -> { published_at(Time.zone.now) }
  scope :yesterday, -> { published_at(1.day.ago) }
  scope :popular, -> { order(total_social: :desc) }

  before_destroy do
    feeds.clear
    categories.clear
  end

  def uri
    Addressable::URI.parse(url)
  end

  private

  def validate_unique_story
    return if publisher.blank?
    other_story = publisher.stories.where(title: title).where.not(id: id).first
    return if other_story.blank?
    errors.add(:url, :invalid) if other_story.uri.path == uri.path
  end
end
