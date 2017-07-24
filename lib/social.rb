module Social
  autoload :Counters, './lib/social/counters'
  autoload :Strategies, './lib/social/strategies'

  class << self
    def count(url)
      entry = find_entry(url)
      return if entry.blank?
      counters_from_entry(entry)
    end

    def counters_from_entry(entry)
      return if entry.blank?
      Social::Counters.new(
        facebook: entry.facebook,
        linkedin: entry.linkedin,
        twitter: entry.twitter,
        pinterest: entry.pinterest,
        google_plus: entry.google_plus
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
