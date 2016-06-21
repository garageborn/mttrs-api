module Extract
  module Strategies
    module Parser
      class Language < Base
        def value
          Utils::Language.find(
            meta_value("itemprop='inLanguage'") || document.xpath('/html').attribute('lang').value
          )
        end
      end
    end
  end
end
