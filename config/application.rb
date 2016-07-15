require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'sprockets/railtie'

require 'rss'
require 'open-uri'
require 'httparty'
require 'thread/pool'
require 'elasticsearch/model'
require 'elasticsearch/rails/instrumentation'

Bundler.require(*Rails.groups)

module Mttrs
  class Application < Rails::Application
    config.time_zone = 'Brasilia'
    config.active_job.queue_adapter = :sidekiq
    config.active_record.timestamped_migrations = false
    config.eager_load_paths += %W(#{ config.root }/lib)
  end
end
