class Namespace
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = { page: 1, per: 20, order_by_slug: true }.freeze

    def model!(params)
      ::Namespace.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page).to_h)
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    model Namespace
  end

  class Form < Operation
    contract Contract

    def process(params)
      validate(params[:namespace]) do
        contract.save
      end
    end
  end

  class Create < Form
    action :create
  end

  class Update < Form
    action :update
  end

  class Destroy < Operation
    include Model
    action :find

    def process(*)
      model.destroy
      model.links.clear
      model.namespaces.clear
    end
  end
end
