class Publisher
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 10).freeze

    def model!(params)
      ::Publisher.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page))
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model Publisher
    contract Contract

    callback :before_destroy, ::Publisher::Callbacks::BeforeDestroy
  end

  class Form < Operation
    def process(params)
      validate(params[:publisher]) do
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
    action :find

    def process(*)
      callback!(:before_destroy)
      model.destroy
    end
  end
end
