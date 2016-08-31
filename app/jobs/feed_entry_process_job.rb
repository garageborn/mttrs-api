class FeedEntryProcessJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options max_performs: {
    count: 2,
    key: proc { |entry| entry[:url] }
  }

  attr_reader :entry

  def perform(entry)
    @entry = entry.with_indifferent_access
    return if entry.blank? || feed.blank? || url.blank?

    add_feed
    result = link.save
    return unless result
    enqueue_link_full_fetch
    enqueue_social_counter_fetcher
    enqueue_link_assigner
    enqueue_story_builder
    result
  end

  private

  def feed
    return if entry[:feed_id].blank?
    Feed.find_by_id(entry[:feed_id])
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
    FullFetchLinkJob.perform_async(link.id)
  end

  def enqueue_social_counter_fetcher
    SocialCounterFetcherJob.perform_async(link.id)
  end

  def enqueue_link_assigner
    LinkAssignerJob.perform_async(link.id)
  end

  def enqueue_story_builder
    return unless link.missing_story?
    StoryBuilderJob.perform_async(link.id)
  end

  memoize :feed, :url, :link
end
