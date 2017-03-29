class TagMatcher
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(
      page: 1,
      per: 10,
      order_by_category_name: true,
      order_by_tag_name: true,
      order_by_publisher_name: true
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
    include Callback
    model TagMatcher
    contract Contract

    callback :after_save, Callbacks::AfterSave
  end

  class Create < Operation
    action :create

    def process(params)
      validate(params[:tag_matcher]) do
        return if contract.try_out
        contract.save
        callback!(:after_save)
      end
    end
  end

  class Update < Operation
    action :update

    def process(params)
      validate(params[:tag_matcher]) do
        return if contract.try_out
        contract.save
        callback!(:after_save)
      end
    end
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
