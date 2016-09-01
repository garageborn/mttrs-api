class Namespace < ApplicationRecord
  include Concerns::Filterable

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :feeds
  has_and_belongs_to_many :links
  has_many :stories, through: :links

  scope :order_by_links_count, lambda {
    joins(:links).group('namespaces.id').order('count(namespaces.id) desc')
  }
  scope :order_by_slug, -> { order(:slug) }
end
