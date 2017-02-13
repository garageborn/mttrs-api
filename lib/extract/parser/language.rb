module Extract
  module Parser
    class Language < Base
      def value
        Utils::Language.find(in_language || html_language)
      end

      private

      def in_language
        meta_value("itemprop='inLanguage'")
      end

      def html_language
        attribute = document.xpath('/html').attribute('lang')
        return attribute.value if attribute.present?
      end
    end
  end
end
