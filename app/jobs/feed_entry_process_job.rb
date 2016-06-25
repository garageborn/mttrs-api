class FeedEntryProcessJob < ActiveJob::Base
  extend Memoist
  attr_reader :feed_id, :entry

  def perform(feed_id, entry)
    @feed_id = feed_id
    @entry = entry
    return if entry.blank? || feed.blank? || url.blank?

    add_feed
    return unless link.save
    enqueue_link_full_fetch
    enqueue_social_counter_fetcher
    enqueue_link_categorizer
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

  def enqueue_link_categorizer
    LinkCategorizerJob.perform_later(link.id)
  end

  def enqueue_social_counter_fetcher
    SocialCounterFetcherJob.perform_later(link.id)
  end

  def enqueue_link_full_fetch
    return unless link.needs_full_fetch?
    FullFetchLinkJob.perform_later(link.id)
  end

  memoize :feed, :url, :link
end
