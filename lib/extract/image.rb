class Extract
  class Image < Base
    def value
      meta_image || matcher_value(:image_source_url)
    end

    private

    def meta_image
      meta_value("property='og:image'") || meta_value("itemprop='image'")
    end
  end
end
