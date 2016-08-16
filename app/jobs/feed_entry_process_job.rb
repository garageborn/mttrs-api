class FeedEntryProcessJob
  include Sidekiq::Worker
  include Concerns::MaxPerforms
  extend Memoist

  max_performs 2, key: proc { |_feed_id, entry| entry[:url] }
  attr_reader :feed_id, :entry

  def perform(feed_id, entry)
    @feed_id = feed_id
    @entry = entry
    return if entry.blank? || feed.blank? || url.blank?

    add_feed
    result = link.save
    return unless result
    enqueue_link_full_fetch
    enqueue_social_counter_fetcher
    enqueue_link_categorizer
    enqueue_story_builder
    result
  end

  private

  def feed
    Feed.find_by_id(feed_id)
  end

  def url
    Utils::UrlDiscovery.run(entry[:url])
  end

  def link
    Link.where(url: url).first_or_initialize.tap do |link|
      link.description ||= entry[:summary]
      link.image_source_url ||= entry[:image]
      link.published_at ||= Time.zone.at(entry[:published].to_i) || Time.zone.now
      link.publisher ||= feed.publisher
      link.source_url ||= entry[:url]
      link.title ||= entry[:title]
    end
  end

  def add_feed
    return if link.feeds.include?(feed)
    link.feeds << feed
  end

  def enqueue_link_full_fetch
    return unless link.missing_html?
    FullFetchLinkJob.perform_later(link.id)
  end

  def enqueue_social_counter_fetcher
    SocialCounterFetcherJob.perform_later(link.id)
  end

  def enqueue_link_categorizer
    return unless link.missing_categories?
    LinkCategorizerJob.perform_later(link.id)
  end

  def enqueue_story_builder
    return unless link.missing_story?
    StoryBuilderJob.perform_later(link.id)
  end

  memoize :feed, :url, :link
end
