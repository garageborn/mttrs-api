class Publisher < ActiveRecord::Base
  extend FriendlyId

  has_many :stories, inverse_of: :publisher, dependent: :destroy
  has_many :feeds, inverse_of: :publisher, dependent: :destroy
  has_many :categories, through: :feeds

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :domain, presence: true

  friendly_id :name, use: %i(slugged finders)
end
