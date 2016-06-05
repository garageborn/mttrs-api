class BuzzsumoFetcherJob < ActiveJob::Base
  extend Memoist

  def perform
    entries.each { |entry| proccess(entry) }
  end

  private

  def domains
    Publisher.pluck(:domain)
  end

  def entries
    query = {
      q: domains.join(' OR '),
      num_results: 100,
      # begin_date: 15.minutes.ago.to_i
    }
    response = Buzzsumo.articles(query: query)
    return [] if response.blank? || response.parsed_response.blank?
    response.parsed_response.results.to_a
  end

  def proccess(entry)
    BuzzsumoEntryProcessJob.perform_later(entry.to_h)
  end

  memoize :domains, :entries
end
