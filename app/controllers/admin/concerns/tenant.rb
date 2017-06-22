module Admin
  module Concerns
    module Tenant
      extend ActiveSupport::Concern

      included do
        helper_method :current_tenant
        before_action :set_timezone
      end

      def default_url_options
        { tenant_name: current_tenant }
      end

      def current_tenant
        Apartment::Tenant.current
      end

      def set_timezone
        tenant_options = Apartment.tenant_options[current_tenant]
        return if tenant_options[:timezone].blank?
        Time.zone = tenant_options[:timezone]
      end
    end
  end
end
