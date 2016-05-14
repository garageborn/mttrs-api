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
    RSS::Parser.parse(open(feed.url))
  end

  def proccess(item)
    feed.publisher.stories.where(url: item.link).first_or_create.tap do |story|
      story.feeds << feed unless story.feeds.include?(feed)
    end
  end

  memoize :feed, :rss
end
