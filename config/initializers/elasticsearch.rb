require 'faraday_middleware/aws_signers_v4'

ELASTICSEARCH_URL = ENV.fetch('ELASTICSEARCH_URL', 'http://localhost:9200')

ELASTICSEARCH_OPTIONS = {
  adapter: :typhoeus,
  host: ELASTICSEARCH_URL,
  logger: Rails.logger,
  request_timeout: 500
}.freeze

if /amazonaws\.com/ =~ ELASTICSEARCH_URL
  ELASTICSEARCH_CLIENT = Elasticsearch::Client.new(ELASTICSEARCH_OPTIONS.dup) do |f|
    f.request(
      :aws_signers_v4,
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
      service_name: 'es',
      region: ENV['AWS_DEFAULT_REGION']
    )
  end
else
  ELASTICSEARCH_CLIENT = Elasticsearch::Client.new(ELASTICSEARCH_OPTIONS.dup)
end

Elasticsearch::Model.client = ELASTICSEARCH_CLIENT
