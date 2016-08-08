module Social
  module Strategies
    module Direct
      autoload :Facebook, './lib/social/strategies/direct/facebook'
      autoload :GooglePlus, './lib/social/strategies/direct/google_plus'
      autoload :Linkedin, './lib/social/strategies/direct/linkedin'
      autoload :Pinterest, './lib/social/strategies/direct/pinterest'
      autoload :Finder, './lib/social/strategies/direct/finder'

      class << self
        extend Memoist

        def count(url)
          finder = Social::Strategies::Direct::Finder.new(url)
          return if finder.run.blank?
          finder.counters
        end
      end
    end
  end
end
