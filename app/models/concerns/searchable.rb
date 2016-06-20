module Concerns
  module Searchable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model

      settings index: {} do
        mapping do
          indexes :title, analyzer: 'snowball'
          indexes :published_at, type: 'date'
        end
      end

      def as_indexed_json(options = {})
        self.as_json(only: %i(title description))
      end

      protected

      def description_text
        ActionView::Base.full_sanitizer.sanitize(description).strip
      end
    end
  end
end
