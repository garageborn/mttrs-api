class FeedFetcherJob
  include Sidekiq::Worker
  extend Memoist

  attr_reader :feed_id

  def perform(feed_id)
    @feed_id = feed_id
    return if feed.blank? || rss.blank?

    rss.entries.each { |entry| proccess(entry) }
  end

  private

  def feed
    Feed.find_by_id(feed_id)
  end

  def rss
    return if request.blank? || request.body.blank?
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

  def request
    direct_request || proxied_request
  end

  def direct_request
    request = Utils::UrlFetcher.run(feed.url)
    return request if request.success?
  end

  def proxied_request
    request = Proxy.request(feed.url)
    return request if request.success?
  end

  memoize :feed, :rss, :request, :direct_request, :proxied_request
end
