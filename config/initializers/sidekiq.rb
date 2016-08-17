require 'sidekiq'
require 'redis-namespace'
require ::File.expand_path('../../../lib/max_performs', __FILE__)

REDIS_URL = ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379')
REDIS_NAMESPACE = "mttrs-api:#{ ENV['RAILS_ENV'] }"
REDIS_TIMEOUT = ENV.fetch('REDIS_TIMEOUT', 10_000).to_i / 1_000 # seconds
REDIS_OPTIONS = { url: REDIS_URL, namespace: REDIS_NAMESPACE, network_timeout: REDIS_TIMEOUT }

Sidekiq.configure_client do |config|
  config.redis = REDIS_OPTIONS.merge(size: ENV.fetch('SIDEKIQ_REDIS_CLIENT_SIZE', 1).to_i)
  config.client_middleware do |chain|
    chain.add MaxPerforms::Client
  end
end

Sidekiq.configure_server do |config|
  config.redis = REDIS_OPTIONS.merge(size: ENV.fetch('SIDEKIQ_REDIS_SERVER_SIZE', 35).to_i)
  config.client_middleware do |chain|
    chain.add MaxPerforms::Client
  end
  config.server_middleware do |chain|
    chain.add MaxPerforms::Server
    chain.remove Sidekiq::Middleware::Server::RetryJobs
  end
end

Sidekiq.default_worker_options = {
  retry: false,
  unique: :until_executed,
  unique_args: ->(args) { args.first.except('job_id') }
}
