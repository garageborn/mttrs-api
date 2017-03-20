module Extract
  class Title < Base
    def value
      meta_title || tag_value('title') || matcher_value(:title)
    end

    private

    def meta_title
      meta_value("property='og:title'") || meta_value("name='title'")
    end
  end
end
