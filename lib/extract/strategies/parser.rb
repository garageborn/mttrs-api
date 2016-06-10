module Extract
  module Strategies
    module Parser
      autoload :Base, './lib/extract/strategies/parser/base'
      autoload :Description, './lib/extract/strategies/parser/description'
      autoload :Image, './lib/extract/strategies/parser/image'
      autoload :Title, './lib/extract/strategies/parser/title'

      class << self
        def run(url, options = {})
          html = options[:html] || get_html(url)
          entry = find_entry(html)
          return if entry.blank?
          page_from_entry(entry)
        end

        def page_from_entry(entry)

          return if entry.blank?
          Extract::Page.new(entry)
        end

        private

        def find_entry(html)
          return if html.blank?
          document = Nokogiri::HTML(html)
          entry = {
            description: Extract::Strategies::Parser::Description.new(document).value,
            image: Extract::Strategies::Parser::Image.new(document).value,
            title: Extract::Strategies::Parser::Title.new(document).value,
            html: html
          }
          return unless entry.any? { |_key, value| value.present? }
          entry
        end

        def get_html(url)
          url_fetcher = UrlFetcher.run(url)
          return unless url_fetcher.success?
          url_fetcher.response.body.encode('UTF-8', 'ISO-8859-1')
        end
      end
    end
  end
end
