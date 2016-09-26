class IndexerJob
  include Shoryuken::Worker
  extend Memoist

  shoryuken_options queue: :indexer

  def perform(operation, klass, record_id, options = {})
    return unless Rails.env.production?
    Rails.logger.debug [operation, "#{ klass }##{ record_id } #{ options.inspect }"]

    case operation
    when /index|update/
      record = klass.constantize.find(record_id)
      record.__elasticsearch__.client = client
      record.__elasticsearch__.__send__ "#{ operation }_document"
    when /delete/
      client.delete(
        index: klass.constantize.index_name,
        type: klass.constantize.document_type,
        id: record_id
      )
    else
      raise ArgumentError, "Unknown operation '#{ operation }'"
    end
  end

  private

  def client
    Elasticsearch::Client.new(
      host: ENV.fetch('ELASTICSEARCH_URL', 'http://localhost:9200'),
      logger: Rails.logger
    )
  end

  memoize :client
end
