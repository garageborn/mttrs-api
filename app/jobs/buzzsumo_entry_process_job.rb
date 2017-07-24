class BuzzsumoEntryProcessJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options queue: :buzzsumo_entry_process, retry: false
  attr_reader :entry
  delegate :publisher, to: :entry

  def perform(entry)
    @entry = BuzzsumoEntry.new(entry)
    return unless @entry.valid?

    operation = link.blank? ? Link::Create : Link::Update
    operation.run(link: attributes) do |op|
      enqueue_update_counters!(op.model)
    end
  end

  def enqueue_update_counters!(model)
    counters = Social.counters_from_entry(entry)
    return if counters.blank?
    ::SocialCounter::UpdateCounters.run(link: model, counters: counters.to_h)
  end

  private

  def link
    Link.find_by_url(entry.url)
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
    images = [link.try(:image_source_url), entry.image_source_url].compact.uniq
    images.find do |image|
      image.present? && !publisher.blocked_urls.match?(image)
    end
  end

  def language
    entry.language || link.try(:language)
  end

  def published_at
    Time.zone.at(entry.published_at) || link.try(:published_at) || Time.zone.now
  end

  def publisher_id
    link.try(:publisher_id) || publisher.id
  end

  def title
    publisher.title_replacements.apply(entry.title || link.try(:title))
  end

  def urls
    link.try(:urls) || Utils::UrlDiscovery.run(entry.url)
  end

  def blocked_url?
    publisher.blocked_urls.match?(entry.url) || publisher.blocked_urls.match?(urls)
  end

  memoize :link, :urls, :attributes
end
