module Admin
  module Layout
    module Cell
      class Application < Trailblazer::Cell
      end

      class Navigation < Trailblazer::Cell
        def tenant_names
          options_for_select(Apartment.tenant_names, Apartment::Tenant.current)
        end
      end
    end
  end
end
