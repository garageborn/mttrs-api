class StoryCategorizerJob < ActiveJob::Base
  extend Memoist
  attr_reader :story_id

  def perform(story_id)
    @story_id = story_id
    return if story.blank?

    categories.each do |category|
      next if story.categories.include?(category)
      story.categories << category
    end
  end

  private

  def story
    Story.find_by_id(story_id)
  end

  def categories
    feeds_categories = story.feeds.map(&:category).to_a
    matchers_categories = StoryCategorizer.run(story).to_a
    [feeds_categories + matchers_categories].flatten.compact.uniq
  end

  memoize :story, :categories
end
