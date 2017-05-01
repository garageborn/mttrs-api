require 'sidekiq'
require 'redis-namespace'

REDIS_URL = ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379').freeze
REDIS_NAMESPACE = ENV['MTTRS_API_REDIS_NAMESPACE'].freeze
REDIS_TIMEOUT = ENV.fetch('REDIS_TIMEOUT', 10_000).to_i / 1_000 # seconds
REDIS_OPTIONS = {
  driver: :hiredis,
  url: REDIS_URL,
  namespace: REDIS_NAMESPACE,
  network_timeout: REDIS_TIMEOUT
}.freeze

Sidekiq.configure_client do |config|
  config.redis = REDIS_OPTIONS.merge(size: ENV.fetch('SIDEKIQ_REDIS_CLIENT_SIZE', 2).to_i)
end

Sidekiq.configure_server do |config|
  config.redis = REDIS_OPTIONS.merge(size: ENV.fetch('SIDEKIQ_REDIS_SERVER_SIZE', 40).to_i)
end

Sidekiq.default_worker_options = {
  retry: false,
  unique: :until_executed,
  unique_args: ->(args) { args.first.except('job_id') },
  log_duplicate_payload: true
}
