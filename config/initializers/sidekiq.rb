require 'sidekiq'
require 'redis-namespace'
Sidekiq.remove_delay!

REDIS_OPTIONS = {
  url: ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379')
}

Sidekiq.configure_client do |config|
  config.redis = REDIS_OPTIONS.merge(size: ENV.fetch('SIDEKIQ_REDIS_CLIENT_SIZE', 1).to_i)
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.remove Sidekiq::Middleware::Server::RetryJobs
  end

  config.redis = REDIS_OPTIONS.merge(size: ENV.fetch('SIDEKIQ_REDIS_SERVER_SIZE', 35).to_i)
end

Sidekiq.default_worker_options = {
  retry: false,
  unique: :until_executed,
  unique_args: ->(args) { args.first.except('job_id') }
}
