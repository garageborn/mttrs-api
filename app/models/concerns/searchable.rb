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

      def similar
        self.class.search(
          min_score: 1.5,
          # aggregations: {
          #   published: {
          #     filter: { bool: { must: [match_all: {}] } },
          #     # aggregations: {
          #     #   published: { date_histogram: { field: 'published_at', interval: 'week' } }
          #     # }
          #     aggregations: {
          #       range: {
          #         field: :published_at,
          #         ranges: [
          #           { from: 'now-10m' },
          #           { to: 'now-10m' }
          #         ]
          #       }
          #     }
          #   }
          # },
          aggregations: {
            range: {
              date_range: {
                field: :published_at,
                ranges: [
                  { from: 'now' },
                  # { to: 'now-10m' }
                ]
              }
            }
          },
          query: {
            more_like_this: {
              fields: [:title, :description],
              like: [{ _id: id }],
              max_query_terms: 100,
              # min_doc_freq: 1,
              min_term_freq: 1,
              minimum_should_match: '80%'
            }
          }
        ).results
      end
    end
  end
end
