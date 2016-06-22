class BuzzsumoEntryProcessJob < ActiveJob::Base
  extend Memoist
  attr_reader :entry

  def perform(entry)
    @entry = entry
    return if entry.blank? || publisher.blank? || url.blank?

    return unless link.save
    enqueue_social_counter_update
    enqueue_link_categorizer
    enqueue_link_full_fetch
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

  def enqueue_social_counter_update
    counters = Social::Strategies::Buzzsumo.counters_from_entry(entry)
    return if counters.blank?
    SocialCounterUpdateJob.perform_later(link.id, counters.to_h)
  end

  def enqueue_link_categorizer
    LinkCategorizerJob.perform_later(link.id)
  end

  def enqueue_link_full_fetch
    return unless link.needs_full_fetch?
    FullFetchLinkJob.perform_later(link.id)
  end

  memoize :publisher, :url, :link
end
