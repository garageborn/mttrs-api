class Extract
  extend Memoist
  autoload :Page, './lib/extract/page'
  autoload :Base, './lib/extract/base'

  autoload :Description, './lib/extract/description'
  autoload :Image, './lib/extract/image'
  autoload :Language, './lib/extract/language'
  autoload :PublishedAt, './lib/extract/published_at'
  autoload :Title, './lib/extract/title'

  AVAILABLE_ATTRIBUTES = %i[description image language published_at title html].freeze

  attr_reader :entry, :force_attributes, :page, :publisher

  def self.run(page, options = {})
    extract = Extract.new(page, options)
    extract.run
    extract.page
  end

  def initialize(page, options = {})
    @page = page
    @publisher = options.delete(:publisher)
    @force_attributes = options.delete(:force_attributes) || []
  end

  def run
    return if entry.blank?
    page.merge(entry)
  end

  private

  def entry
    return if html.blank?

    page.html = html
    attrs = attributes.map { |attr| [attr, get_attribute(attr)] }
    Hash[attrs]
  end

  def get_attribute(attribute)
    klass = "Extract::#{ attribute.to_s.classify }".constantize
    klass.new(document, publisher: publisher).value
  end

  def html
    return page.html unless page.html.blank?
    url_fetcher = Utils::UrlFetcher.run(page.url)
    return unless url_fetcher&.success?
    url_fetcher.body
  end

  def attributes
    attrs = AVAILABLE_ATTRIBUTES & page.missing_attributes
    attrs.delete(:html)
    attrs.concat(force_attributes).compact.uniq
  end

  def document
    Nokogiri::HTML(page.html)
  end

  memoize :attributes, :document, :entry, :html
end
