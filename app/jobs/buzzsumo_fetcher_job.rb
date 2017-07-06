class BuzzsumoFetcherJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options queue: :buzzsumo_fetcher, retry: false
  attr_reader :publisher_id, :options

  ENTRY_KEYS = %i[
    google_plus_shares
    language
    linkedin_shares
    pinterest_shares
    published_date
    thumbnail
    title
    total_facebook_shares
    twitter_shares
    url
  ].freeze

  def perform(publisher_id, options = {})
    @publisher_id = publisher_id
    @options = options.with_indifferent_access
    return if publisher.blank?

    entries.each { |entry| process(entry) }
  end

  private

  def publisher
    Utils::Thread.with_connection do
      Publisher.find_by(id: publisher_id)
    end
  end

  def entries
    publisher.publisher_domains.map do |publisher_domain|
      query = query_for(publisher_domain.domain)
      Buzzsumo::Articles.all(query: query)
    end.flatten.compact.uniq
  end

  def query_for(domain)
    options.clone.tap do |query|
      query[:q] = domain
      query[:language] = publisher.language
      query[:max_pages] ||= 2
      query[:num_results] ||= 100
      query[:num_days] ||= 5 if query[:begin_date].blank? && query[:end_date].blank?
    end
  end

  def process(entry)
    attributes = entry.to_h.with_indifferent_access.select { |key, _| ENTRY_KEYS.include?(key) }
    BuzzsumoEntryProcessJob.perform_async(attributes)
  end

  memoize :publisher, :entries
end
