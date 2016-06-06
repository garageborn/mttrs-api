class Story < ActiveRecord::Base
  include Concerns::Filterable

  belongs_to :publisher
  has_many :social_counters, inverse_of: :story, dependent: :destroy
  has_one :social_counter, -> { order(id: :desc) }
  has_and_belongs_to_many :feeds
  has_many :categories, through: :feeds

  validates :title, :publisher, :published_at, presence: true
  validates :source_url, :url, presence: true, uniqueness: { case_sensitive: false }
  validate :validate_unique_story

  scope :category_slug, -> (slug) { joins(:categories).where(categories: { slug: slug }) }
  scope :created_at, -> (date) { created_between(date.at_beginning_of_day, date.end_of_day) }
  scope :created_between, -> (start_at, end_at) { where(created_at: start_at..end_at) }
  scope :created_since, -> (date) { where('stories.created_at >= ?', date) }
  scope :created_until, -> (date) { where('stories.created_at <= ?', date) }
  scope :last_month, -> { created_since(1.month.ago) }
  scope :last_week, -> { created_since(1.week.ago) }
  scope :recent, -> { order(created_at: :desc) }
  scope :today, -> { created_at(Time.zone.now) }
  scope :yesterday, -> { created_at(1.day.ago) }
  scope :popular, -> { order(total_social: :desc) }

  def missing_info?
    title.blank? || description.blank?
  end

  def missing_image?
    image_source_url.blank?
  end

  def missing_content?
    content.blank?
  end

  def needs_full_fetch?
    missing_info? || missing_image? || missing_content?
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
