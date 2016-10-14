class BuzzsumoEntryProcessJob
  include Sidekiq::Worker
  extend Memoist

  attr_reader :entry

  def perform(entry)
    @entry = entry.with_indifferent_access
    return if entry.blank? || publisher.blank?

    Link::Create.run(link: attributes) do |op|
      enqueue_update_counters!(op.model)
    end
  end

  def enqueue_update_counters!(model)
    counters = Social::Strategies::Buzzsumo.counters_from_entry(entry)
    return if counters.blank?
    ::SocialCounter::UpdateCounters.run(link: model, counters: counters.to_h)
  end

  private

  def publisher
    Publisher.find_by_host(entry[:url])
  end

  def link
    Link.find_by_url(entry[:url])
  end

  def attributes
    {
      image_source_url: image_source_url,
      published_at: published_at,
      publisher_id: publisher_id,
      title: title,
      urls: urls
    }
  end

  def image_source_url
    link.try(:image_source_url) || entry[:thumbnail]
  end

  def published_at
    link.try(:published_at) || Time.zone.at(entry[:published_date].to_i) || Time.zone.now
  end

  def publisher_id
    link.try(:publisher_id) || publisher.id
  end

  def title
    link.try(:title) || entry[:title]
  end

  def urls
    link.try(:urls) || Utils::UrlDiscovery.run(entry[:url])
  end

  memoize :link, :publisher, :urls, :attributes
end
