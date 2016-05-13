class Source < ActiveRecord::Base
  has_and_belongs_to_many :links

  validates :name, :rss, presence: true, uniqueness: { case_sensitive: false }

  after_commit :instrument_creation, on: :create

  private

  def instrument_creation
    ActiveSupport::Notifications.instrument('source.created', self)
  end
end
