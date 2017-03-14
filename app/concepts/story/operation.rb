class Story
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 20, popular: true).freeze

    def model!(params)
      ::Story.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.
        merge(published_at: Time.zone.today).
        merge(params.permit(:category_slug, :page, :published_at))
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model Story
    contract Contract

    callback :after_update, Callbacks::AfterUpdate
  end

  class Create < Operation
    action :create

    def process(params)
      validate(params[:story]) do
        contract.save
      end
    end
  end

  class Update < Operation
    action :update

    def process(params)
      validate(params[:story]) do
        contract.save
        callback!(:after_update)
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
