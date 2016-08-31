class Feed < ApplicationRecord
  include Concerns::Filterable
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

  def uri
    Addressable::URI.parse(url)
  end
end
