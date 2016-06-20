module Extract
  module Strategies
    module Parser
      autoload :Base, './lib/extract/strategies/parser/base'
      autoload :Description, './lib/extract/strategies/parser/description'
      autoload :Image, './lib/extract/strategies/parser/image'
      autoload :Title, './lib/extract/strategies/parser/title'
      AVAILABLE_ATTRIBUTES = %i(description image language title html).freeze

      class << self
        def run(page)
          entry = find_entry(page)
          return if entry.blank?
          page.merge(entry)
        end

        private

        def find_entry(page)
          attributes = (AVAILABLE_ATTRIBUTES & page.missing_attributes) - [:html]
          return if attributes.blank?
          page.html ||= get_html(page.url)
          return if page.html.blank?

          document = Nokogiri::HTML(page.html)
          attrs = attributes.map { |attr| [attr, get_attribute(document, attr)] }
          Hash[attrs]
        end

        def get_attribute(document, attribute)
          klass = "Extract::Strategies::Parser::#{ attribute.to_s.classify }".constantize
          klass.new(document).value
        end

        def get_html(url)
          url_fetcher = Utils::UrlFetcher.run(url)
          return unless url_fetcher.success?
          url_fetcher.response.body.encode('UTF-8', 'ISO-8859-1')
        end
      end
    end
  end
end
