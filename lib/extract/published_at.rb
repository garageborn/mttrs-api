class Extract
  class PublishedAt < Base
    def value
      published_at = matcher_value(:published_at)
      return if published_at.blank?
      Date.parse(published_at)
    rescue ArgumentError
    end
  end
end
