module Social
  autoload :Counters, './lib/social/counters'
  autoload :Strategies, './lib/social/strategies'

  class << self
    def count(url)
      strategies.each do |strategy|
        counters = strategy.count(url)
        next if counters.blank?
        break counters
      end
    end

    private

    def strategies
      Strategies.ordered
    end

    def fetch_social(source, url)
      count = source.count(url)
      return if count.blank?
      name = source.name.underscore.split('/').last.to_sym
      { name => count }
    end
  end
end
