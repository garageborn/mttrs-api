class FeedFetcherJob < ActiveJob::Base
  extend Memoist

  def perform(feed_id)
    @feed_id = feed_id
    return if feed.blank?

    rss.items.each { |item| proccess(item) }
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
    RSS::Parser.parse(request.body)
  end

  def proccess(item)
    feed.publisher.stories.where(source_url: item.link).first_or_initialize.tap do |story|
      story.title ||= item.title
      story.description ||= item.description
      story.feeds << feed unless story.feeds.include?(feed)
      story.save
    end
  end

  memoize :feed, :rss
end
