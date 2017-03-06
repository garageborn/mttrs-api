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

  def matchers_categories
    link.publisher.category_matchers.ordered.to_a.detect do |category_matcher|
      LinkCategorizer::Matcher.new(category_matcher, link).match?
    end.try(:category)
  end

  def feeds_categories
    link.feeds.map(&:categories).to_a
  end

  memoize :matchers_categories, :feeds_categories, :categories
end
