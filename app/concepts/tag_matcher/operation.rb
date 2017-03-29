class TagMatcher
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(
      page: 1,
      per: 10,
      order_by_category_name: true,
      order_by_tag_name: true
    ).freeze

    def model!(params)
      ::TagMatcher.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page))
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    model TagMatcher
    contract Contract
  end

  class Create < Operation
    action :create

    def process(params)
      validate(params[:tag_matcher]) do
        contract.save
      end
    end
  end

  class Update < Operation
    action :update

    def process(params)
      validate(params[:tag_matcher]) do
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
