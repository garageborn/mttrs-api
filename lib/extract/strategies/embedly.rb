module Extract
  module Strategies
    module Embedly
      AVAILABLE_ATTRIBUTES = %i(content description image title).freeze

      class << self
        def run(page)
          entry = find_entry(page)
          return if entry.blank?
          page.merge(
            content: entry[:content],
            description: entry[:description],
            image: entry[:images].try(:first).try(:url),
            title: entry[:title]
          )
        end

        private

        def find_entry(page)
          return if page.url.blank?
          return unless Rails.env.production?
          embedly = ::Embedly.extract(page.url)
          return unless embedly.success?
          embedly.parsed_response
        end
      end
    end
  end
end
