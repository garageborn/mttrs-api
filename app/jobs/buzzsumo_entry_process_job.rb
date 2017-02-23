class BuzzsumoEntryProcessJob
  include Sidekiq::Worker
  extend Memoist

  attr_reader :entry

  def perform(entry)
    @entry = entry.with_indifferent_access
    return if entry.blank? || publisher.blank? || blocked_url?

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
      language: language,
      published_at: published_at,
      publisher_id: publisher_id,
      title: title,
      urls: urls
    }
  end

  def image_source_url
    image = entry[:thumbnail] || link.try(:image_source_url)
    return if publisher.blocked_urls.match?(image)
    image
  end

  def language
    entry[:language] || link.try(:language)
  end

  def published_at
    Time.zone.at(entry[:published_date].to_i) || link.try(:published_at) || Time.zone.now
  end

  def publisher_id
    link.try(:publisher_id) || publisher.id
  end

  def title
    publisher.title_replacements.apply(entry[:title] || link.try(:title))
  end

  def urls
    link.try(:urls) || Utils::UrlDiscovery.run(entry[:url])
  end

  def blocked_url?
    publisher.blocked_urls.match?(entry[:url]) || publisher.blocked_urls.match?(urls)
  end

  memoize :link, :publisher, :urls, :attributes
end
