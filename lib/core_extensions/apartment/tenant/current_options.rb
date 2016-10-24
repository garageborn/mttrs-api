module CoreExtensions
  module Apartment
    module Tenant
      module CurrentOptions
        def current_options
          ::Apartment.tenant_options[current.to_sym]
        end
      end
    end
  end
end
