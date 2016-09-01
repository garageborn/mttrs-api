module Tenant
  module Concerns
    module Model
      extend ActiveSupport::Concern

      included do
        class << self
          def tenant(options)
            p '--------'
          end

          def tenant_scope
            Tenant.current.each do |key, value|

            end
          end
        end
      end
    end
  end
end
