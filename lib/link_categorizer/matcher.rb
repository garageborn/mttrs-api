class LinkCategorizer
  class Matcher
    extend Memoist

    attr_reader :category_matcher, :link
    delegate :category, to: :category_matcher

    def initialize(category_matcher, link)
      @category_matcher = category_matcher
      @link = link
    end

    def match?
      return false unless link.available_on_current_tenant?
      match_url?
    end

    private

    def match_url?
      return false if category_matcher.url_matcher.blank?
      regexp = Regexp.new(category_matcher.url_matcher, Regexp::IGNORECASE)
      link.url.match(regexp).present?
    end

    memoize :match?, :match_url?
  end
end
