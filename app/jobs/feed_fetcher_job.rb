class FeedFetcherJob
  include Sidekiq::Worker
  extend Memoist

  attr_reader :feed_id

  def perform(feed_id)
    @feed_id = feed_id
    return if feed.blank? || rss.blank?

    rss.entries.each { |entry| process(entry) }
  end

  private

  def feed
    Utils::Thread::with_connection do
      Feed.find_by(id: feed_id)
    end
  end

  def rss
    return if request_body.blank?
    Feedjira::Feed.parse(request_body)
  end

  def process(entry)
    return if Link.find_by_url(entry.url)
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
    return request if request&.success?
  end

  def proxied_request
    request = Proxy.request(feed.url)
    return request if request.success?
  end

  def request_body
    return if request&.body.blank?
    request.body.encode('utf-8')
  rescue Encoding::UndefinedConversionError
    request.body
  end

  memoize :feed, :rss, :request, :direct_request, :proxied_request
end
