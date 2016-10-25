MTTRS_API_SENTRY_DSN = ENV['MTTRS_API_SENTRY_DSN'].freeze

if defined?(Raven) && MTTRS_API_SENTRY_DSN.present?
  Raven.configure do |config|
    config.dsn = MTTRS_API_SENTRY_DSN
  end
end
