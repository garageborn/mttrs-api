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
    return if entry.blank? || feed.blank? || urls.blank?

    Link::Create.run(link: attributes) do |op|
      @link = op.model
      add_feed
    end
  end

  private

  def link
    @link ||= ::Link.find_by_url(entry[:url])
  end

  def feed
    Feed.find_by_id(entry[:feed_id])
  end

  def urls
    Utils::UrlDiscovery.run(entry[:url])
  end

  def attributes
    description = link.try(:description) || entry[:summary]
    image_source_url = link.try(:image_source_url) || entry[:image]
    published_at = link.try(:published_at) || Time.zone.at(entry[:published].to_i) || Time.zone.now
    publisher_id = link.try(:publisher_id) || feed.publisher_id
    title = link.try(:title) || entry[:title]

    {
      description: description,
      image_source_url: image_source_url,
      published_at: published_at,
      publisher_id: publisher_id,
      title: title,
      urls: urls
    }
  end

  def add_feed
    return if link.feeds.include?(feed)
    link.feeds << feed
  end

  memoize :urls, :attributes
end
