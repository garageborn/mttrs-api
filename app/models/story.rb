class Story < ActiveRecord::Base
  include Concerns::CloudinaryAsset

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

  private

  def instrument_creation
    ActiveSupport::Notifications.instrument('story.created', self)
  end
end
