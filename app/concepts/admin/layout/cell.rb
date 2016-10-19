module Admin
  module Layout
    module Cell
      class Application < Trailblazer::Cell
        delegate :insert_paloma_hook, to: :controller
      end

      class Navigation < Trailblazer::Cell
        def tenant_names
          options_for_select(Apartment.tenant_names, Apartment::Tenant.current)
        end
      end
    end
  end
end
