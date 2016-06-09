class FeedFetcherJob < ActiveJob::Base
  extend Memoist

  def perform(feed_id)
    @feed_id = feed_id
    return if feed.blank?

    rss.entries.each { |entry| proccess(entry) }
  end

  private

  def feed
    Feed.find_by_id(@feed_id)
  end

  def rss
    request = UrlFetcher.run(feed.url)
    Feedjira::Feed.parse(request.body)
  end

  def proccess(entry)
    FeedEntryProcessJob.perform_later(
      feed.id,
      title: entry.title,
      url: entry.url,
      published: entry.published.to_i,
      summary: entry.summary || entry.content,
      image: entry.image
    )
  end

  memoize :feed, :rss
end
