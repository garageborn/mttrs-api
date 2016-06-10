module Extract
  module Strategies
    module Embedly
      class << self
        def run(url, _options = {})
          entry = find_entry(url)
          return if entry.blank?
          page_from_entry(entry)
        end

        def page_from_entry(entry)
          return if entry.blank?
          Extract::Page.new(
            content: entry[:content],
            description: entry[:description],
            image: entry[:images].try(:first).try(:url),
            title: entry[:title]
          )
        end

        private

        def find_entry(url)
          return unless Rails.env.production?
          embedly = ::Embedly.extract(url)
          return unless embedly.success?
          embedly.parsed_response
        end
      end
    end
  end
end
