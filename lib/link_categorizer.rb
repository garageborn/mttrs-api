class LinkCategorizer
  extend Memoist
  autoload :Matcher, './lib/link_categorizer/matcher'

  attr_reader :link

  class << self
    def run(link)
      new(link).category
    end
  end

  def initialize(link)
    @link = link
  end

  def category
    link.publisher.category_matchers.ordered.to_a.detect do |category_matcher|
      LinkCategorizer::Matcher.new(category_matcher, link).match?
    end.try(:category)
  end


  memoize :category
end
