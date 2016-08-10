if defined? Raven
  Raven.configure do |config|
    config.dsn = ENV.fetch('MTTRS_API_SENTRY_DSN')
    config.environments = %w(production)
    config.tags = { environment: Rails.env }
    config.processors = [Raven::Processor::SanitizeData]
    config.async = lambda do |event|
      Thread.new { Raven.send(event) }
    end
  end
end
