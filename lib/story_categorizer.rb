class StoryCategorizer
  extend Memoist
  autoload :Matcher, './lib/story_categorizer/matcher'

  attr_reader :story

  class << self
    def run(story)
      new(story).categories
    end
  end

  def initialize(story)
    @story = story
  end

  def categories
    matchers.select(&:match?).map(&:category)
  end

  private

  def matchers
    story.publisher.category_matchers.ordered.map do |category_matcher|
      StoryCategorizer::Matcher.new(category_matcher, story)
    end
  end

  memoize :matchers, :categories
end
