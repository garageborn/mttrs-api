module Concerns
  module Similar
    extend ActiveSupport::Concern

    included do
      extend Memoist

      def self.find_similar(options = {})
        query = options.delete(:query)
        exclude = options.delete(:exclude) || []
        published_at = options.delete(:published_at)

        default_options = {
          min_score: 1.5,
          size: 1_000,
          query: {
            bool: {
              must: {
                match: { title: query }
              },
              must_not: {
                ids: { values: exclude }
              },
              filter: {
                range: {
                  published_at: {
                    gte: published_at.at_beginning_of_day.to_i,
                    lte: published_at.end_of_day.to_i
                  }
                }
              }
            }
          }
        }

        search(default_options.merge(options))
      end

      def similar(options = {})
        return if new_record?
        SimilarLinks.new(options.merge(base_link: self))
      end

      def find_similar(options = {})
        return if new_record?

        self.class.find_similar(
          options.merge(query: title, exclude: [id], published_at: published_at)
        )
      end

      memoize :similar
    end
  end
end
