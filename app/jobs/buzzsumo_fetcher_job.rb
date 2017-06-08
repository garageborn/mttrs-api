class BuzzsumoFetcherJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options queue: :link_fetcher, retry: false
  attr_reader :publisher_id, :options

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
      query[:max_pages] ||= 1
      query[:num_results] ||= 100
      query[:num_days] ||= 7 if query[:begin_date].blank? && query[:end_date].blank?
    end
  end

  def process(entry)
    BuzzsumoEntryProcessJob.perform_async(entry.to_h)
  end

  memoize :publisher, :entries
end
