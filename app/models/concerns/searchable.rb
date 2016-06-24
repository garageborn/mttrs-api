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

      after_commit -> { IndexerJob.perform_later('index', self.class.to_s, id) }, on: :create
      after_commit -> { IndexerJob.perform_later('update', self.class.to_s, id) }, on: :update
      after_commit -> { IndexerJob.perform_later('delete', self.class.to_s, id) }, on: :destroy
      after_touch -> { IndexerJob.perform_later('update', self.class.to_s, id) }

      def as_indexed_json(options = {})
        as_json(options.merge(only: %i(title description published_at)))
      end
    end
  end
end
