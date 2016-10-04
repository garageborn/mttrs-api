module Admin
  module Concerns
    module Tenant
      extend ActiveSupport::Concern

      included do
        helper_method :current_tenant
      end

      def default_url_options
        { tenant_name: current_tenant }
      end

      def current_tenant
        Apartment::Tenant.current
      end
    end
  end
end
