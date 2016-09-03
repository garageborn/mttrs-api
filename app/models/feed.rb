class Feed < ApplicationRecord
  include Concerns::Filterable
  include Tenant::Concerns::Model

  belongs_to :publisher
  belongs_to :category
  has_and_belongs_to_many :links
  has_and_belongs_to_many :namespaces

  validates :publisher, :category, presence: true
  validates :url, presence: true, uniqueness: { case_sensitive: false }
  validates :language, presence: true, inclusion: { in: Utils::Language::EXISTING_LANGUAGES }

  scope :order_by_links_count, lambda {
    joins(:links).group('feeds.id').order('count(feeds.id) desc')
  }
  scope :namespace, lambda { |id|
    joins(:feeds_namespaces).where(feeds_namespaces: { namespace_id: id })
  }

  tenant namespace: :namespace

  def uri
    Addressable::URI.parse(url)
  end
end
