require 'sidekiq'

REDIS_URL = ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379')
REDIS_NAMESPACE = "mttrs-api_#{ ENV['RAILS_ENV'] }"

Sidekiq.configure_client do |config|
  config.redis = {
    url: REDIS_URL,
    size: ENV.fetch('SIDEKIQ_REDIS_CLIENT_SIZE', 1).to_i,
    namespace: REDIS_NAMESPACE
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: REDIS_URL,
    size: ENV.fetch('SIDEKIQ_REDIS_SERVER_SIZE', 35).to_i,
    namespace: REDIS_NAMESPACE
  }
end

Sidekiq.default_worker_options = {
  retry: false,
  unique: :until_executed,
  unique_args: ->(args) { args.first.except('job_id') }
}
