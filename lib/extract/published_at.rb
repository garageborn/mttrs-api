module Extract
  class PublishedAt < Base
    def value
      matcher_value(:published_at)
    end
  end
end
