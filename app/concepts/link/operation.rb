require ::File.expand_path('../callbacks', __FILE__)

class Link
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 100, recent: true).freeze

    def model!(params)
      ::Link.available_on_current_tenant.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page, :publisher_slug))
    end
  end

  class Uncategorized < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 50, order_by_url: true).freeze

    def model!(params)
      ::Link.available_on_current_tenant.uncategorized.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page, :publisher_slug))
    end
  end

  class Similar < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 50, recent: true).freeze

    def model!(params)
      ::Link.available_on_current_tenant.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page))
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model Link
    contract Contract

    callback :after_create, Callbacks::AfterCreate
    callback :after_update, Callbacks::AfterUpdate
    callback :before_destroy, Callbacks::BeforeDestroy
  end

  class Create < Form
    action :create

    def process(params)
      validate(params[:link]) do
        contract.save
        callback!(:after_create)
      end
    end
  end

  class Update < Form
    action :update

    def process(params)
      p '------------------params[:link]', params[:link]

      validate(params[:link]) do
        contract.save
        callback!(:after_update)
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
      callback!(:before_destroy)
      model.destroy
    end
  end

  class RemoveFromStory < Operation
    action :find

    def process(*)
      StoryLink::Destroy.run(id: model.story_link.id)
      StoryBuilderJob.perform_async(model.id)
    end
  end
end
