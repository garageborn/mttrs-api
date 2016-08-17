class FeedFetcherJob
  include Sidekiq::Worker
  extend Memoist

  attr_reader :feed_id

  def perform(feed_id)
    @feed_id = feed_id
    return if feed.blank?

    rss.entries.each { |entry| proccess(entry) }
  end

  private

  def feed
    Feed.find_by_id(feed_id)
  end

  def rss
    request = Utils::UrlFetcher.run(feed.url)
    Feedjira::Feed.parse(request.body)
  end

  def proccess(entry)
    return if Link.where(url: entry.url).or(Link.where(source_url: entry.url)).exists?
    FeedEntryProcessJob.perform_async(
      feed_id: feed.id,
      title: entry.title,
      url: entry.url,
      published: entry.published.to_i,
      summary: entry.summary || entry.content,
      image: entry.image
    )
  end

  memoize :feed, :rss
end
