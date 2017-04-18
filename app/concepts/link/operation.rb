require ::File.expand_path('../callbacks', __FILE__)

class Link
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 100, recent: true).freeze

    def model!(params)
      ::Link.available_on_current_tenant.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:category_slug, :page, :publisher_slug, :tag_slug))
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

    callback :after_save, Callbacks::AfterSave
    callback :before_destroy, Callbacks::BeforeDestroy
  end

  class Form < Operation
    contract Contract

    private

    def model!(params)
      return ::Link.find(params[:id]) if params[:id].present?
      urls = params[:link].try(:[], :urls)
      return ::Link.new(params[:link]) if urls.blank?
      ::Link.find_by_url(urls) || ::Link.new(params[:link])
    end
  end

  class Create < Form
    action :create

    def process(params)
      validate(params[:link]) do
        model.save
        callback!(:after_save)
      end
    end
  end

  class Update < Form
    action :update

    def process(params)
      validate(params[:link]) do
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
      callback!(:before_destroy)
      model.destroy
    end
  end
end
