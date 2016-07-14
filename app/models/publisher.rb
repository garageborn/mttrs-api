class Publisher < ApplicationRecord
  extend FriendlyId

  has_many :links, inverse_of: :publisher, dependent: :destroy
  has_many :feeds, inverse_of: :publisher, dependent: :destroy
  has_many :categories, through: :feeds
  has_many :category_matchers, inverse_of: :publisher, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :domain, presence: true

  friendly_id :name, use: %i(slugged finders)
end
