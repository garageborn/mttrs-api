class Publisher
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 50, order_by_name: true).freeze

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

    callback :after_create, ::Publisher::Callbacks::AfterCreate
    callback :before_destroy, ::Publisher::Callbacks::BeforeDestroy
  end

  class Create < Operation
    action :create

    def process(params)
      validate(params[:publisher]) do
        contract.save
        callback!(:after_create)
      end
    end
  end

  class Update < Operation
    action :update

    def process(params)
      validate(params[:publisher]) do
        contract.save
      end
    end
  end

  class Destroy < Operation
    action :find

    def process(*)
      callback!(:before_destroy)
      model.destroy
    end
  end
end
