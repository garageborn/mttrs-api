module Tenant
  module Scopes
    autoload :Namespace, './lib/tenant/scopes/namespace'

    class << self
      def all
        [Namespace]
      end

      def find(key)
        "Tenant::Scopes::#{ key.to_s.classify }".constantize
      end

      def config(key, value)
        find(key).parse(value)
      end
    end
  end
end
