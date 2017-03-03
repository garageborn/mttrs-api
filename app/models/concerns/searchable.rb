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

      def similar
        self.class.search(
          min_score: 1.5,
          size: 1_000,
          query: {
            bool: {
              must: {
                match: { title: title }
              },
              must_not: {
                ids: { values: [id] }
              },
              filter: {
                range: {
                  published_at: {
                    gte: published_at.at_beginning_of_day,
                    lte: published_at.end_of_day
                  }
                }
              }
            }
          }
        )
      end
    end
  end
end
