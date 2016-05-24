class SocialCounterUpdateJob < ActiveJob::Base
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

  def social_counter
    story.social_counter || story.build_social_counter
  end

  def update
    social.each_pair { |provider, count| update_counter(provider, count) }
    social_counter.save if social_counter.changed?
  end

  def update_counter(provider, value)
    value = value.to_i
    return if value.blank?
    return if social_counter.read_attribute(provider) > value
    social_counter[provider] = value
  end

  memoize :story, :social, :social_counter
end
