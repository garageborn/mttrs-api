module Extract
  module Strategies
    autoload :Parser, './lib/extract/strategies/parser'

    class << self
      def ordered
        [Extract::Strategies::Parser]
      end
    end
  end
end
