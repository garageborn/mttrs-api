class BuzzsumoFetcherJob
  include Sidekiq::Worker
  extend Memoist

  attr_reader :publisher_id

  def perform(publisher_id)
    @publisher_id = publisher_id
    return if publisher.blank?

    entries.each { |entry| process(entry) }
  end

  private

  def publisher
    Publisher.find_by_id(publisher_id)
  end

  def entries
    query = { q: publisher.domain, num_results: 100, language: 'en', num_days: 7 }
    Buzzsumo.all(:articles, query: query)
  end

  def process(entry)
    BuzzsumoEntryProcessJob.perform_async(entry.to_h)
  end

  memoize :publisher, :entries
end
