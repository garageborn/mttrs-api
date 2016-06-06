class Category < ActiveRecord::Base
  include Concerns::Filterable
  extend FriendlyId

  has_and_belongs_to_many :stories
  has_many :category_matchers, inverse_of: :category, dependent: :destroy
  has_many :feeds, inverse_of: :category
  has_many :publishers, through: :stories

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :order_by_name, -> { order(:name) }
  scope :order_by_stories_count, lambda {
    joins(:stories).group('categories.id').order('count(categories.id) desc')
  }

  before_destroy do
    feeds.clear
    stories.clear
  end

  friendly_id :name, use: %i(slugged finders)
end
