class CategoryMatcher
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(
      order_by_publisher_name: true,
      ordered: true,
      page: 1,
      per: 100
    ).freeze

    def model!(params)
      ::CategoryMatcher.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page))
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model CategoryMatcher
    contract Contract

    callback :after_save, Callbacks::AfterSave
  end

  class Form < Operation
    def process(params)
      validate(params[:category_matcher]) do
        return if contract.try_out
        contract.save
        callback!(:after_save)
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
