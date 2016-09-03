class Namespace < ApplicationRecord
  include Concerns::Filterable

  has_many :stories, through: :links

  scope :order_by_links_count, lambda {
    joins(:links).group('namespaces.id').order('count(namespaces.id) desc')
  }
  scope :order_by_slug, -> { order(:slug) }

  def categories
    Category.namespace(id)
  end

  def feeds
    Feed.namespace(id)
  end

  def links
    Link.namespace(id)
  end
end
