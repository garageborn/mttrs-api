class Feed < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :category
  has_and_belongs_to_many :stories

  validates :publisher, :category, presence: true
  validates :url, presence: true, uniqueness: { case_sensitive: false }

  after_commit :instrument_creation, on: :create

  scope :order_by_stories_count, lambda {
    joins(:stories).group('feeds.id').order('count(feeds.id) desc')
  }

  private

  def instrument_creation
    ActiveSupport::Notifications.instrument('feed.created', self)
  end
end
