class Namespace < ApplicationRecord
  include Concerns::Filterable

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
