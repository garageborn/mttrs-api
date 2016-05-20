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
      next if count.blank?
      next if story.social[provider.to_s].to_i > count.to_i
      story.social[provider.to_s] = count.to_i
    end
    story.social.delete_if { |_, value| value.to_i < 1 }
    story.save if story.changed?
  end

  memoize :story, :social
end
