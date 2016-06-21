module Concerns
  module Searchable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model

      settings index: {} do
        mapping do
          indexes :title, analyzer: 'snowball'
          indexes :description, analyzer: 'snowball'
          indexes :published_at, type: 'date'
        end
      end

      def as_indexed_json(options = {})
        as_json(options.merge(only: %i(title description published_at)))
      end

      protected

      def description_text
        ActionView::Base.full_sanitizer.sanitize(description).strip
      end
    end
  end
end
