module Tenant
  module Concerns
    module Model
      extend ActiveSupport::Concern

      included do
        class << self
          def tenant(options)
            return if options.blank?

            default_scope lambda {
              scope = all
              Tenant.current.each do |key, value|
                next unless options[key]
                scope = scope.send(key, value)
              end
              scope
            }
          end
        end
      end
    end
  end
end
