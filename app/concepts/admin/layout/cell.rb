module Admin
  module Layout
    module Cell
      class Application < Trailblazer::Cell
        delegate :insert_paloma_hook, to: :controller
      end

      class Navigation < Trailblazer::Cell
        def tenant_names
          tenant_names = Apartment.tenant_names.sort.map do |tenant_name|
            tenant = tenant_name.to_sym
            options = Apartment.tenant_options[tenant]
            [options[:country], tenant_name]
          end

          options_for_select(tenant_names, Apartment::Tenant.current)
        end
      end
    end
  end
end
