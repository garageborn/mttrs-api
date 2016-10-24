class Story
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 10, recent: true).freeze

    def model!(params)
      ::Story.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page))
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    model Story
    contract Contract
  end

  class Form < Operation
    def process(params)
      validate(params[:story]) do
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
      model.destroy
    end
  end
end
