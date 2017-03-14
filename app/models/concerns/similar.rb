module Concerns
  module Similar
    extend ActiveSupport::Concern

    included do
      extend Memoist

      def similar(options = {})
        return if new_record?
        SimilarLinks.new(self).tap do |similar_links|
          find_similar(options).records.each_with_hit do |record, hit|
            similar_links.add(record, hit)
            similar_links.merge(record.find_similar(options).records)
          end
        end
      end

      def find_similar(options = {})
        return if new_record?
        default_options = {
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
        }
        self.class.search(default_options.merge(options))
      end

      memoize :similar
    end
  end
end
