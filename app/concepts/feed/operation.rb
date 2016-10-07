class Feed
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(
      page: 1, per: 20, order_by_links_count: true
    ).freeze

    def model!(params)
      ::Feed.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page).to_h)
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model Feed
    contract Contract

    callback :after_save, ::Feed::Callbacks::AfterSave
    callback :before_destroy, ::Feed::Callbacks::BeforeDestroy
  end

  class Form < Operation
    def process(params)
      validate(params[:feed]) do
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
      callback!(:before_destroy)
      model.destroy
    end
  end
end
