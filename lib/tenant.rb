module Tenant
  autoload :Concerns, './lib/tenant/concerns'
  autoload :Scopes, './lib/tenant/scopes'

  class << self
    def config(options)
      config = {}
      options.each do |key, value|
        scope_config = Scopes.config(key, value)
        next if scope_config.blank?
        config.merge!(scope_config)
      end
      Thread.current[:tenant] = config
    end

    def current
      Thread.current[:tenant]
    end
  end
end
