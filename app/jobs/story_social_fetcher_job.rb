class StorySocialFetcherJob < ActiveJob::Base
  extend Memoist

  def perform(story_id)
    @story_id = story_id
    return if story.blank?

    update
  end

  private

  def story
    Story.find_by_id(@story_id)
  end

  def social
    SocialShare.count(story.url)
  end

  def update
    social.each_pair do |provider, count|
      next if story.social[provider].to_i > count
      story.social[provider] = count
    end
    story.save if story.changed?
  end

  memoize :story, :social
end
