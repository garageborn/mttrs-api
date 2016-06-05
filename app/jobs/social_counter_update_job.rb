class SocialCounterUpdateJob < ActiveJob::Base
  extend Memoist
  attr_reader :story_id, :counters

  def perform(story_id, counters = {})
    @story_id = story_id
    @counters = counters
    return if story.blank? || counters.blank?

    update
  end

  private

  def story
    Story.find_by_id(story_id)
  end

  def social_counter
    return story.social_counters.build if last_social_counter.blank?
    story.social_counters.build(parent: last_social_counter).tap do |social_counter|
      SocialCounter::PROVIDERS.each do |provider|
        social_counter[provider] = last_social_counter.read_attribute(provider)
      end
    end
  end

  def last_social_counter
    story.social_counter
  end

  def update
    counters.each { |provider, count| update_counter(provider, count) }
    social_counter.save if social_counter.increased?
  end

  def update_counter(provider, value)
    value = value.to_i
    provider = provider.to_sym
    return if value.blank?
    return if social_counter.read_attribute(provider) > value
    social_counter[provider] = value
  end

  memoize :story, :social_counter, :last_social_counter
end
