class BuzzsumoFetcherJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options queue: :buzzsumo_fetcher, retry: false
  attr_reader :publisher_id, :options

  MIN_TOTAL_SOCIAL = 10.freeze
  SOCIAL_KEYS = %i[
    google_plus_shares
    linkedin_shares
    pinterest_shares
    total_facebook_shares
    twitter_shares
  ].freeze
  ENTRY_KEYS = %i[language published_date thumbnail title url].merge(SOCIAL_KEYS).freeze

  def perform(publisher_id, options = {})
    @publisher_id = publisher_id
    @options = options.with_indifferent_access
    return if publisher.blank?

    entries.each { |entry| process(entry.to_h.with_indifferent_access) }
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
    return unless processable_entry?(entry)
    attributes = entry.select { |key, _value| ENTRY_KEYS.include?(key.to_sym) }
    BuzzsumoEntryProcessJob.perform_async(attributes)
  end

  def processable_entry?(entry)
    social = entry.select { |key, _value| SOCIAL_KEYS.include?(key.to_sym) }
    total_social social.map { |_key, value| value.to_i }.sum
    total_social > MIN_TOTAL_SOCIAL
  end

  memoize :publisher, :entries
end
