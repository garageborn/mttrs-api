require 'faraday_middleware/aws_signers_v4'

ELASTICSEARCH_OPTIONS = {
  host: ENV.fetch('ELASTICSEARCH_URL', 'http://localhost:9200'),
  logger: Rails.logger
}

ELASTICSEARCH_CLIENT = Elasticsearch::Client.new(ELASTICSEARCH_OPTIONS) do |f|
  f.request(
    :aws_signers_v4,
    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
    service_name: 'es',
    region: ENV['AWS_REGION']
  )
end
