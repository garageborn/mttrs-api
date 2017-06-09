require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'sprockets/railtie'
require 'sprockets/es6'

require 'rss'
require 'open-uri'
require 'httparty'
require 'thread/pool'
require 'elasticsearch/model'
require 'elasticsearch/rails/instrumentation'

Bundler.require(*Rails.groups)

module Mttrs
  class Application < Rails::Application
    config.time_zone = 'UTC'
    config.active_record.timestamped_migrations = false
    config.i18n.available_locales = %w(en pt)
    config.eager_load_paths += %W(
      #{ config.root }/lib
      #{ config.root }/app/graph/resolvers
      #{ config.root }/app/graph/types
      #{ config.root }/app/graph/mutations
      #{ config.root }/app/graph
    )
    config.assets.precompile += %w(
      admin/application.css
      admin/application.js
    )
  end
end
