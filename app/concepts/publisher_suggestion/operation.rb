class PublisherSuggestion
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 50, order_by_count: true).freeze

    def model!(params)
      ::PublisherSuggestion.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page))
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    model PublisherSuggestion
    contract Contract
  end

  class Create < Operation
    action :create

    def process(params)
      validate(params[:publisher_suggestion]) do
        contract.save
      end
    end
  end

  class Update < Operation
    action :update

    def process(params)
      validate(params[:publisher_suggestion]) do
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
