module Social
  module Strategies
    module Direct
      class Finder
        extend Memoist

        SOURCES = [
          Social::Strategies::Direct::Facebook,
          Social::Strategies::Direct::GooglePlus,
          Social::Strategies::Direct::Linkedin,
          Social::Strategies::Direct::Pinterest
        ].freeze

        attr_accessor :url, :entry

        def initialize(url)
          @url = url
          @entry = {}
        end

        def run
          SOURCES.each { |source| process_source(source) }
          pool.shutdown
          return if entry.blank?
          entry
        end

        def counters
          return if entry.blank?
          Social::Counters.new(entry)
        end

        private

        def pool
          Thread.pool(SOURCES.size)
        end

        def process_source(source)
          pool.process do
            social = fetch_social(source)
            entry.merge!(social) unless social.blank?
          end
        end

        def fetch_social(source)
          count = source.count(url)
          return if count.blank?
          name = source.name.underscore.split('/').last.to_sym
          { name => count }
        end

        memoize :pool, :counters
      end
    end
  end
end
