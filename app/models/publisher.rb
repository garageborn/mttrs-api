class Publisher < ApplicationRecord
  include Concerns::Filterable
  include Concerns::TenantOptions
  extend FriendlyId

  has_many :blocked_urls, inverse_of: :publisher, dependent: :destroy
  has_many :category_matchers, inverse_of: :publisher, dependent: :destroy
  has_many :links, inverse_of: :publisher, dependent: :destroy
  has_many :publisher_domains, inverse_of: :publisher, dependent: :destroy
  has_many :stories, -> { distinct }, through: :links
  has_many :title_replacements, inverse_of: :publisher, dependent: :destroy

  friendly_id :name, use: %i(slugged finders)

  scope :available_on_current_tenant, -> { with_tenant_language }
  scope :order_by_name, -> { order(:name) }
  scope :with_stories, -> { joins(:stories).group('publishers.id') }
  scope :with_tenant_language, lambda {
    next all if current_tenant_languages.blank?
    joins(:links).where(links: { language: current_tenant_languages }).distinct
  }

  def self.find_by_host(url)
    host = Addressable::URI.parse(url).host
    public_suffix = PublicSuffix.domain(host)
    domains = [host, public_suffix].uniq
    return if domains.blank?
    joins(:publisher_domains).find_by(publisher_domains: { domain: domains })
  end
end
