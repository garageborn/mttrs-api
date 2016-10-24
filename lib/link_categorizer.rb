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
    (feeds_categories + matchers_categories).flatten.compact.uniq
  end

  private

  def matchers
    link.publisher.category_matchers.map do |category_matcher|
      LinkCategorizer::Matcher.new(category_matcher, link)
    end
  end

  def matchers_categories
    matchers.select(&:match?).map(&:category).to_a
  end

  def feeds_categories
    link.feeds.map(&:categories).to_a
  end

  memoize :matchers, :matchers_categories, :feeds_categories, :categories
end
