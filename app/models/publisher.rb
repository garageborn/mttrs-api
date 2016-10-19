class Publisher < ApplicationRecord
  include Concerns::Filterable
  extend FriendlyId

  has_many :category_matchers, inverse_of: :publisher, dependent: :destroy
  has_many :feeds, inverse_of: :publisher, dependent: :destroy
  has_many :links, inverse_of: :publisher, dependent: :destroy
  has_many :stories, -> { distinct }, through: :links

  friendly_id :name, use: %i(slugged finders)

  scope :order_by_name, -> { order(:name) }

  def self.find_by_host(url)
    host = Addressable::URI.parse(url).host
    public_suffix = PublicSuffix.domain(host)
    find_by(domain: [host, public_suffix].uniq)
  end
end
