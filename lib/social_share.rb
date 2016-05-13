module SocialShare
  autoload :Facebook, './lib/social_share/facebook'
  autoload :Linkedin, './lib/social_share/linkedin'

  class << self
    def count(url)
      pool = Thread.pool(sources.size)
      OpenStruct.new.tap do |counters|
        sources.each do |source|
          name = source.name.underscore.split('/').last.to_sym
          counters[name] = source.count(url)
        end
        pool.shutdown
      end
    end

    def sources
      [Facebook, Linkedin]
    end
  end
end
