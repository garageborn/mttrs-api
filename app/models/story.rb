class Story < ActiveRecord::Base
  include Concerns::CloudinaryAsset
  include Concerns::Filterable

  belongs_to :publisher
  has_and_belongs_to_many :feeds
  has_many :categories, through: :feeds

  enum status: %i(pending fetching ready error)
  cloudinary_asset :image, attribute: :image_public_id, styles: {
    thumb: { width: 200, height: 200, crop: :fit, fetch_format: 'auto', dpr: 'auto' },
  }

  validates :publisher, :status, presence: true
  validates :url, presence: true, uniqueness: { case_sensitive: false }

  after_commit :instrument_creation, on: :create

  scope :category_slug, -> (slug) { joins(:categories).where(categories: { slug: slug }) }
  scope :created_at, -> (date) { created_between(date.at_beginning_of_day, date.end_of_day) }
  scope :created_between, -> (start_at, end_at) { where(created_at: start_at..end_at) }
  scope :created_since, -> (date) { where('stories.created_at >= ?', date) }
  scope :last_month, -> { created_since(1.month_ago.ago) }
  scope :last_week, -> { created_since(1.week.ago) }
  scope :recent, -> { order(created_at: :desc) }
  scope :today, -> { created_at(Time.zone.now) }
  scope :yesterday, -> { created_at(1.day.yesterday) }

  private

  def instrument_creation
    ActiveSupport::Notifications.instrument('story.created', self)
  end
end
