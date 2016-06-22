class LinkCategorizer
  extend Memoist
  autoload :Matcher, './lib/link_categorizer/matcher'

  attr_reader :link

  class << self
    def run(link)
      new(link).categories
    end
  end

  def initialize(link)
    @link = link
  end

  def categories
    matchers.select(&:match?).map(&:category)
  end

  private

  def matchers
    link.publisher.category_matchers.ordered.map do |category_matcher|
      LinkCategorizer::Matcher.new(category_matcher, link)
    end
  end

  memoize :matchers, :categories
end
