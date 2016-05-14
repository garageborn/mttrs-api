class Category < ActiveRecord::Base
  has_many :feeds, inverse_of: :category
  has_many :publishers, through: :feeds
  has_many :stories, through: :feeds

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :order_by_name, -> { order(:name) }
  scope :order_by_stories_count, lambda {
    joins(:stories).group('categories.id').order('count(categories.id) desc')
  }
end
