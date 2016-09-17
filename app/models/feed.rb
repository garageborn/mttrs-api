class Feed < ApplicationRecord
  include Concerns::Filterable

  belongs_to :publisher
  has_many :categories, through: :category_feeds
  has_many :category_feeds, inverse_of: :feed, dependent: :destroy
  has_many :feed_links, inverse_of: :feed, dependent: :destroy
  has_many :links, through: :feed_links

  before_destroy :destroy_tenant_associations!

  scope :order_by_links_count, lambda {
    joins(:links).group('feeds.id').order('count(feeds.id) desc')
  }

  def uri
    Addressable::URI.parse(url)
  end

  private

  def destroy_tenant_associations!
    Apartment::Tenant.each do
      model = reload
      model.category_feeds.try(:destroy_all)
      model.feed_links.try(:destroy_all)
    end
  end
end
