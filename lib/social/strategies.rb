module Social
  module Strategies
    autoload :Buzzsumo, './lib/social/strategies/buzzsumo'
    autoload :Direct, './lib/social/strategies/direct'

    class << self
      def ordered
        # [Social::Strategies::Buzzsumo, Social::Strategies::Direct]
        [Social::Strategies::Direct]
      end
    end
  end
end
