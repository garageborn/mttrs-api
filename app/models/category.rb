class Category < ApplicationRecord
  include Concerns::Filterable
  extend FriendlyId

  has_and_belongs_to_many :links
  has_many :category_matchers, inverse_of: :category, dependent: :destroy
  has_many :feeds, inverse_of: :category, dependent: :destroy
  has_many :publishers, through: :links

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :order_by_name, -> { order(:name) }
  scope :order_by_links_count, lambda {
    joins(:links).group('categories.id').order('count(categories.id) desc')
  }

  # before_destroy { links.clear }

  friendly_id :name, use: %i(slugged finders)
end
