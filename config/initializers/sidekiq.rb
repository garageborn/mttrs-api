require 'sidekiq'

REDIS_URL = ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379')

Sidekiq.configure_client do |config|
  config.redis = {
    url: REDIS_URL,
    size: ENV.fetch('SIDEKIQ_REDIS_CLIENT_SIZE', 1).to_i
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: REDIS_URL,
    size: ENV.fetch('SIDEKIQ_REDIS_SERVER_SIZE', 5).to_i
  }
end

Sidekiq.default_worker_options = {
  retry: false
}
