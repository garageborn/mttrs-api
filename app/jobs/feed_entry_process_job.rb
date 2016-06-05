class FeedEntryProcessJob < ActiveJob::Base
  extend Memoist
  attr_reader :feed_id, :entry

  def perform(feed_id, entry)
    @feed_id = feed_id
    @entry = entry

    return if entry.blank? || feed.blank?
    return if Story.where(url: url).where.not(id: story.id).exists?

    add_feed
    enqueue_story_full_fetch if story.save
  end

  private

  def feed
    Feed.find_by_id(feed_id)
  end

  def story
    story = Story.where(source_url: entry[:url])
    story = Story.where(url: url) unless story.exists?
    story.first_or_initialize.tap do |story|
      story.url ||= url
      story.title ||= entry[:title]
      story.description ||= entry[:summary]
      story.image_source_url ||= entry[:image]
      story.source_url ||= entry[:url]
    end
  end

  def url
    url = entry[:url]
    head = HTTParty.head(url, headers: { 'User-Agent' => '' }, verify: false)
    url = head.request.last_uri.to_s if head.success?
  rescue HTTParty::Error
  ensure
    return Addressable::URI.parse(url).omit(:query, :fragment).to_s
  end

  def add_feed
    return if story.feeds.include?(feed)
    story.feeds << feed
    story.publisher ||= feed.publisher
  end

  def enqueue_story_full_fetch
    return unless story.needs_full_fetch?
    FullFetchStoryJob.perform_later(story.id)
  end

  memoize :feed, :story, :url
end
