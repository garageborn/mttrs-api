class Publisher < ApplicationRecord
  include Concerns::Filterable
  include Concerns::TenantOptions
  extend FriendlyId

  has_many :category_matchers, inverse_of: :publisher, dependent: :destroy
  has_many :feeds, inverse_of: :publisher, dependent: :destroy
  has_many :links, inverse_of: :publisher, dependent: :destroy
  has_many :stories, -> { distinct }, through: :links

  friendly_id :name, use: %i(slugged finders)

  scope :available_on_current_tenant, -> { with_tenant_language }
  scope :order_by_name, -> { order(:name) }
  scope :with_tenant_language, lambda {
    next all if current_tenant_languages.blank?
    joins(:links).where(links: { language: current_tenant_languages }).distinct
  }

  def self.find_by_host(url)
    host = Addressable::URI.parse(url).host
    public_suffix = PublicSuffix.domain(host)
    find_by(domain: [host, public_suffix].uniq)
  end
end
