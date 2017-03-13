module Concerns
  module Searchable
    extend ActiveSupport::Concern

    included do
      include ::Elasticsearch::Model

      settings index: {} do
        mapping do
          indexes :title, analyzer: 'snowball'
          indexes :published_at, type: 'date'
        end
      end

      after_commit -> { IndexerJob.perform_async('index', self.class.to_s, id) }, on: :create
      after_commit -> { IndexerJob.perform_async('update', self.class.to_s, id) }, on: :update
      after_commit -> { IndexerJob.perform_async('delete', self.class.to_s, id) }, on: :destroy
      after_touch -> { IndexerJob.perform_async('update', self.class.to_s, id) }

      def as_indexed_json(_options = {})
        { published_at: published_at, title: title }
      end
    end
  end
end
