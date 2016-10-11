class BuzzsumoFetcherJob
  include Sidekiq::Worker
  extend Memoist

  attr_reader :publisher_id, :options

  def perform(publisher_id, options = {})
    @publisher_id = publisher_id
    @options = options.with_indifferent_access
    return if publisher.blank?

    entries.each { |entry| process(entry) }
  end

  private

  def publisher
    Publisher.find_by_id(publisher_id)
  end

  def languages
    publisher.feeds.map(&:language).compact.uniq
  end

  def entries
    languages.map do |language|
      Buzzsumo.all(:articles, query: query(language))
    end.flatten.compact.uniq
  end

  def query(language)
    options.clone.tap do |query|
      query[:q] = publisher.domain
      query[:language] = language
      query[:num_results] ||= 100
      query[:num_days] ||= 7 if query[:begin_date].blank? && query[:end_date].blank?
    end
  end

  def process(entry)
    BuzzsumoEntryProcessJob.perform_async(entry.to_h)
  end

  memoize :publisher, :languages, :entries
end
