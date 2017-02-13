module Extract
  class Title < Base
    def value
      meta_value("property='og:title'") || meta_value("name='title'") || tag_value('title')
    end
  end
end
