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
    request = HTTParty.get(
      feed.url,
      headers: { 'User-Agent' => 'Firefox' },
      verify: false
    )
    Feedjira::Feed.parse(request.body)
  end

  def proccess(entry)
    StoryProcessJob.perform_later(
      feed_id: feed.id,
      url: entry.url,
      title: entry.title,
      description: entry.summary,
      image: entry.image
    )
  end

  memoize :feed, :rss
end
