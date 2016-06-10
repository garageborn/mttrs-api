module Extract
  module Strategies
    module Parser
      class Image < Base
        def value
          meta_value("property='og:image'") || meta_value("itemprop='image'")
        end
      end
    end
  end
end
