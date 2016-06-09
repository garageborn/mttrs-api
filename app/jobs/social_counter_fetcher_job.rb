class SocialCounterFetcherJob < ActiveJob::Base
  extend Memoist
  attr_reader :story_id

  def perform(story_id)
    @story_id = story_id
    return if story.blank? || social.blank?

    SocialCounterUpdateJob.perform_later(story.id, social.to_h)
  end

  private

  def story
    Story.find_by_id(story_id)
  end

  def social
    Social.count(story.url) || Social.count(story.source_url)
  end

  memoize :story, :social
end
