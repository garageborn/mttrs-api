class CategoryMatcher
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 10).freeze

    def model!(params)
      ::CategoryMatcher.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page).to_h)
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    model CategoryMatcher
    contract Contract
  end

  class Form < Operation
    def process(params)
      validate(params[:category_matcher]) do
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

  class DestroyAll < Operation
    def process(params)
      return if params.blank?
      params.each { |id| Destroy.run(id: id) }
    end
  end

  class Destroy < Operation
    action :find

    def process(*)
      model.destroy
    end
  end
end
