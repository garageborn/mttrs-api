class StoryCategorizerJob < ActiveJob::Base
  extend Memoist
  attr_reader :story_id

  def perform(story_id)
    @story_id = story_id
    return if story.blank?

    add_categories_from_feeds
    add_categories_from_matchers
  end

  private

  def story
    Story.find_by_id(story_id)
  end

  def add_categories_from_feeds
    story.feeds.each do |feed|
      next if story.categories.include?(feed.category)
      story.categories << feed.category
    end
  end

  def add_categories_from_matchers
    categories = StoryCategorizer.run(story)
    return unless categories.present?

    categories.each do |category|
      next if story.categories.include?(category)
      story.categories << category
    end
  end

  memoize :story
end
