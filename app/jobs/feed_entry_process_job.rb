class FeedEntryProcessJob < ActiveJob::Base
  extend Memoist
  attr_reader :feed_id, :entry

  def perform(feed_id, entry)
    @feed_id = feed_id
    @entry = entry
    return if entry.blank? || feed.blank? || url.blank?

    add_feed
    return unless story.save
    enqueue_story_categorizer
    enqueue_social_counter_fetcher
    enqueue_story_full_fetch
  end

  private

  def feed
    Feed.find_by_id(feed_id)
  end

  def url
    Utils::UrlDiscovery.run(entry[:url])
  end

  def story
    Story.where(url: url).first_or_initialize.tap do |story|
      story.description ||= entry[:summary]
      story.image_source_url ||= entry[:image]
      story.published_at ||= Time.zone.at(entry[:published].to_i) || Time.zone.now
      story.publisher ||= feed.publisher
      story.source_url ||= entry[:url]
      story.title ||= entry[:title]
    end
  end

  def add_feed
    return if story.feeds.include?(feed)
    story.feeds << feed
  end

  def enqueue_story_categorizer
    StoryCategorizerJob.perform_later(story.id)
  end

  def enqueue_social_counter_fetcher
    SocialCounterFetcherJob.perform_later(story.id)
  end

  def enqueue_story_full_fetch
    return unless story.needs_full_fetch?
    FullFetchStoryJob.perform_later(story.id)
  end

  memoize :feed, :url, :story
end
