class BuzzsumoEntryProcessJob
  include Sidekiq::Worker
  include Concerns::MaxPerforms
  extend Memoist

  max_performs 1, key: proc { |entry| entry[:url] }
  attr_reader :entry

  def perform(entry)
    @entry = entry.with_indifferent_access
    return if entry.blank? || publisher.blank? || url.blank?

    result = link.save
    return unless result
    enqueue_link_full_fetch
    enqueue_social_counter_update
    enqueue_link_categorizer
    enqueue_story_builder
    result
  end

  private

  def publisher
    host = Addressable::URI.parse(entry[:url]).host
    public_suffix = PublicSuffix.domain(host)
    Publisher.where(domain: [host, public_suffix]).first
  end

  def url
    Utils::UrlDiscovery.run(entry[:url])
  end

  def link
    Link.where(url: url).first_or_initialize.tap do |link|
      link.image_source_url ||= entry[:image_source_url]
      link.published_at ||= Time.zone.at(entry[:published_date].to_i) || Time.zone.now
      link.publisher = publisher
      link.source_url ||= entry[:url]
      link.title ||= entry[:title]
    end
  end

  def enqueue_link_full_fetch
    return unless link.missing_html?
    FullFetchLinkJob.perform_async(link.id)
  end

  def enqueue_social_counter_update
    counters = Social::Strategies::Buzzsumo.counters_from_entry(entry)
    return if counters.blank?
    SocialCounterUpdateJob.new.perform(link.id, counters.to_h)
  end

  def enqueue_link_categorizer
    LinkCategorizerJob.perform_async(link.id)
  end

  def enqueue_story_builder
    return unless link.missing_story?
    StoryBuilderJob.perform_async(link.id)
  end

  memoize :publisher, :url, :link
end
