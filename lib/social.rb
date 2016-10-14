module Social
  autoload :Counters, './lib/social/counters'
  autoload :Strategies, './lib/social/strategies'

  class << self
    def count(url, strategy:)
      if strategy.to_sym == :buzzsumo
        Strategies::Buzzsumo.count(url)
      else
        Strategies::Direct.count(url)
      end
    end
  end
end
