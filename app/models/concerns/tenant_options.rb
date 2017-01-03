module Concerns
  module TenantOptions
    extend ActiveSupport::Concern

    included do
      def self.current_tenant_languages
        Apartment.tenant_options[Apartment::Tenant.current].try(:[], :languages) || []
      end
    end
  end
end
