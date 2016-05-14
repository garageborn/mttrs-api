class Publisher < ActiveRecord::Base
  has_many :stories, inverse_of: :publisher, dependent: :destroy
  has_many :feeds, inverse_of: :publisher, dependent: :destroy
  has_many :categories, through: :feeds

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
