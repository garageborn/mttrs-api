module Concerns
  module Searchable
    extend ActiveSupport::Concern

    included do
      include ::Elasticsearch::Model

      settings index: {} do
        mapping do
          indexes :title, analyzer: 'snowball'
          indexes :description, analyzer: 'snowball'
          indexes :content, analyzer: 'snowball'
          indexes :published_at, type: 'date'
        end
      end

      after_commit -> { IndexerJob.perform_async('index', self.class.to_s, id) }, on: :create
      after_commit -> { IndexerJob.perform_async('update', self.class.to_s, id) }, on: :update
      after_commit -> { IndexerJob.perform_async('delete', self.class.to_s, id) }, on: :destroy
      after_touch -> { IndexerJob.perform_async('update', self.class.to_s, id) }

      def as_indexed_json(_options = {})
        {
          content: content,
          description: description,
          published_at: published_at,
          title: title
        }
      end

      def similar
        self.class.search(
          min_score: 1,
          size: 1_000,
          query: {
            bool: {
              must: {
                match: { title: title }
              },
              must_not: {
                ids: { values: [id] }
              },
              should: {
                multi_match: {
                  query: title,
                  fields: %w(title^10 description content),
                  operator: :or,
                  type: :cross_fields
                }
              },
              filter: {
                range: {
                  published_at: {
                    lte: published_at + 2.days,
                    gte: published_at - 2.days
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
