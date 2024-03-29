class Category
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 10, ordered: true).freeze

    def model!(params)
      ::Category.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page))
    end
  end

  class Form < Trailblazer::Operation
    include Model
    model Category
    contract Contract

    def process(params)
      validate(params[:category]) do
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

  class Destroy < Trailblazer::Operation
    include Model
    model Category, :find

    def process(*)
      model.destroy
    end
  end
end
