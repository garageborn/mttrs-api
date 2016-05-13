class Link < ActiveRecord::Base
  has_and_belongs_to_many :sources

  enum status: [:pending, :fetching, :ready, :error]

  validates :url, presence: true, uniqueness: { case_sensitive: false }

  after_commit :instrument_creation, on: :create

  private

  def instrument_creation
    ActiveSupport::Notifications.instrument('link.created', self)
  end
end
