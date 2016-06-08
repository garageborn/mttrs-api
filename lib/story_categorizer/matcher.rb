class StoryCategorizer
  class Matcher
    extend Memoist

    attr_reader :category_matcher, :story
    delegate :category, to: :category_matcher

    def initialize(category_matcher, story)
      @category_matcher = category_matcher
      @story = story
    end

    def match?
      match_url?
    end

    private

    def match_url?
      return false if category_matcher.url_matcher.blank?
      regexp = Regexp.new(category_matcher.url_matcher, Regexp::IGNORECASE)
      story.url.match(regexp).present?
    end

    memoize :match?, :match_url?
  end
end
