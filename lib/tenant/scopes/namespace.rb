module Tenant
  module Scopes
    module Namespace
      class << self
        def parse(value)
          namespace = find(value)
          return if namespace.blank?
          { namespace: namespace.id }
        end

        def find(value)
          return if value.blank?
          return ::Namespace.find_by(id: value) if value.to_i.positive?
          ::Namespace.find_by(slug: value)
        end
      end
    end
  end
end
