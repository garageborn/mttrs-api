module Social
  module Strategies
    module Direct
      autoload :Facebook, './lib/social/strategies/direct/facebook'
      autoload :GooglePlus, './lib/social/strategies/direct/google_plus'
      autoload :Linkedin, './lib/social/strategies/direct/linkedin'
      autoload :Pinterest, './lib/social/strategies/direct/pinterest'

      class << self
        def count(url)
          entry = find_entry(url)
          return if entry.blank?
          counters_from_entry(entry)
        end

        def counters_from_entry(entry)
          return if entry.blank?
          Social::Counters.new(entry)
        end

        private

        def sources
          [
            Social::Strategies::Direct::Facebook,
            Social::Strategies::Direct::GooglePlus,
            Social::Strategies::Direct::Linkedin,
            Social::Strategies::Direct::Pinterest
          ]
        end

        def find_entry(url)
          pool = Thread.pool(sources.size)
          Hash.new.tap do |counters|
            sources.each do |source|
              pool.process do
                social = fetch_social(source, url)
                counters.merge!(social) unless social.blank?
              end
            end
            pool.shutdown
            break if counters.blank?
          end
        end

        def fetch_social(source, url)
          count = source.count(url)
          return if count.blank?
          name = source.name.underscore.split('/').last.to_sym
          { name => count }
        end
      end
    end
  end
end
