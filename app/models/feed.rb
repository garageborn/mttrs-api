class Feed < ApplicationRecord
  include Concerns::Filterable

  belongs_to :publisher
  has_many :feed_links, inverse_of: :feed, dependent: :destroy
  has_many :links, through: :feed_links

  scope :order_by_links_count, lambda {
    joins(:links).group('feeds.id').order('count(feeds.id) desc')
  }

  def uri
    Addressable::URI.parse(url)
  end
end
