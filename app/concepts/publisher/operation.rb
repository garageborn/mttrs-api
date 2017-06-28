require ::File.expand_path('../callbacks', __FILE__)
class Publisher
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 50, order_by_name: true).freeze

    def model!(params)
      ::Publisher.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page, :with_stories))
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model Publisher
    contract Contract

    callback :after_create, Callbacks::AfterCreate
    callback :after_update, Callbacks::AfterUpdate
    callback :before_destroy, Callbacks::BeforeDestroy
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
        callback!(:after_update)
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
