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
    return if entry.blank? || feed.blank?

    result, _op = Link::Create.run(link: attributes)
    result
  end

  private

  def link
    Link.find_by_url(entry[:url])
  end

  def feed
    Feed.find_by_id(entry[:feed_id])
  end

  def attributes
    {
      description: description,
      image_source_url: image_source_url,
      published_at: published_at,
      publisher_id: publisher_id,
      title: title,
      urls: urls,
      feed_ids: feed_ids
    }
  end

  def description
    link.try(:description) || entry[:summary]
  end

  def image_source_url
    link.try(:image_source_url) || entry[:image]
  end

  def published_at
    link.try(:published_at) || Time.zone.at(entry[:published].to_i) || Time.zone.now
  end

  def publisher_id
    link.try(:publisher_id) || feed.publisher_id
  end

  def title
    link.try(:title) || entry[:title]
  end

  def urls
    link.try(:urls) || Utils::UrlDiscovery.run(entry[:url])
  end

  def feed_ids
    (link.try(:feed_ids).to_a + [feed.id]).compact.uniq
  end

  memoize :link, :feed, :urls, :attributes
end
