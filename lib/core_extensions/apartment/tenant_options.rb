module CoreExtensions
  module Apartment
    module TenantOptions
      attr_accessor :tenant_options
      def tenant_options=(tenant_options)
        @tenant_options = tenant_options.with_indifferent_access
      end
    end
  end
end
