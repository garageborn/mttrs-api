class Extract
  class Language < Base
    def value
      language = in_language || html_language || matcher_value(:language)
      Utils::Language.find(language)
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
