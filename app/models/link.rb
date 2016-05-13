class Link < ActiveRecord::Base
  include Concerns::CloudinaryAsset

  has_and_belongs_to_many :sources

  enum status: [:pending, :fetching, :ready, :error]
  cloudinary_asset :image, attribute: :image_public_id, styles: {
    thumb: { width: 200, height: 200, crop: :fit, fetch_format: 'auto', dpr: 'auto' },
  }

  validates :url, presence: true, uniqueness: { case_sensitive: false }

  after_commit :instrument_creation, on: :create

  private

  def instrument_creation
    ActiveSupport::Notifications.instrument('link.created', self)
  end
end
