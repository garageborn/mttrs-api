module SocialShare
  autoload :Facebook, './lib/social_share/facebook'
  autoload :Linkedin, './lib/social_share/linkedin'
  POOL_SIZE = 7

  class << self
    def count(url)
      pool = Thread.pool(sources.size)

      counters = {}
      sources.each do |source|
        pool.process do
          social = fetch_social(source, url)
          counters.merge!(social) unless social.blank?
        end
      end
      pool.shutdown
      return if counters.blank?
      OpenStruct.new(counters)
    end

    private

    def sources
      [Facebook, Linkedin]
    end

    def fetch_social(source, url)
      count = source.count(url)
      return if count.blank?
      name = source.name.underscore.split('/').last.to_sym
      { name => count }
    end
  end
end
