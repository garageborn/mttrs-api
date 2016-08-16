module Social
  autoload :Counters, './lib/social/counters'
  autoload :Strategies, './lib/social/strategies'

  class << self
    def count(url)
      Hash.new.tap do |entry|
        strategies.each do |strategy|
          counters = strategy.count(url)
          entry.merge!(counters.to_h) if counters.present?
        end
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
