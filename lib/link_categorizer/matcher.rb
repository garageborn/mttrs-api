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
      match_url? || match_html?
    end

    private

    def match_url?
      return false if category_matcher.url_matcher.blank?
      regexp = Regexp.new(category_matcher.url_matcher, Regexp::IGNORECASE)
      link.url.match(regexp).present?
    end

    def match_html?
      return false if link.page.blank?
      return false if category_matcher.html_matcher.blank? ||
                      category_matcher.html_matcher_selector.blank?
      regexp = Regexp.new(category_matcher.html_matcher, Regexp::IGNORECASE)

      method = category_matcher.html_matcher_selector.start_with?('//') ? :xpath : :css
      selector = link.page.send(method, category_matcher.html_matcher_selector)
      text = Utils::StripAttributes.run(selector.text)
      text.match(regexp).present?
    end

    memoize :match?, :match_url?
  end
end
