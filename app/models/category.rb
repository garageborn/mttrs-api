class Category < ActiveRecord::Base
  has_many :feeds, inverse_of: :category
  has_many :publishers, through: :feeds
  has_many :stories, through: :feeds

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
