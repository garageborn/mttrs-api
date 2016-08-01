class Publisher
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = { page: 1, per: 10 }.freeze

    def model!(params)
      ::Publisher.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page).to_h)
    end
  end

  class Form < Trailblazer::Operation
    include Model
    model Publisher
    contract Contract

    def process(params)
      validate(params[:publisher]) do
        contract.save
      end
    end
  end

  class Create < Form
    action :create
  end

  class Update < Create
    action :update
  end

  class Destroy < Trailblazer::Operation
    include Model
    model Publisher, :find

    def process(*)
      model.destroy
    end
  end
end
