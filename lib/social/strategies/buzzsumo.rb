module Social
  module Strategies
    module Buzzsumo
      class << self
        def count(url)
          entry = find_entry(url)
          return if entry.blank?
          counters_from_entry(entry)
        end

        def counters_from_entry(entry)
          return if entry.blank?
          Social::Counters.new(
            facebook: entry[:total_facebook_shares],
            linkedin: entry[:linkedin_shares],
            twitter: entry[:twitter_shares],
            pinterest: entry[:pinterest_shares],
            google_plus: entry[:google_plus_shares]
          )
        end

        private

        def find_entries(url)
          query = { q: url, num_results: 1 }
          response = ::Buzzsumo::Articles.get(query: query)
          return unless response.success?
          return if response.parsed_response.blank?
          response.parsed_response.results.to_a
        end

        def find_entry(url)
          find_entries(url).to_a.detect { |entry| url == entry[:url] }
        end
      end
    end
  end
end
