class Notification
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 50, recent: true).freeze

    def model!(params)
      ::Notification.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page))
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model Notification
    contract Contract

    callback :after_create, Callbacks::AfterCreate
  end

  class Create < Operation
    action :create

    def process(params)
      validate(params[:notification]) do
        return deliver_try_out_notification if contract.try_out
        contract.save
        callback!(:after_create)
      end
    end

    private

    def deliver_try_out_notification
      ::Notification::Deliver.run(model: contract.sync, try_out: true)
      contract.response = contract.model.response
      contract.onesignal_id = contract.model.onesignal_id
    end
  end

  class Update < Operation
    action :update

    def process(params)
      validate(params[:notification]) do
        contract.save
      end
    end
  end

  class Destroy < Operation
    action :find

    def process(*)
      model.destroy
    end
  end
end
