module Tenant
  module Concerns
    module Controller
      extend ActiveSupport::Concern

      included do
        before_action :set_tenant

        private

        def set_tenant
          Tenant.config(namespace: params[:namespace])
        end
      end
    end
  end
end
