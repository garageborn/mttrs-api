require ::File.expand_path('../callbacks', __FILE__)

class Link
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = { page: 1, per: 30, recent: true }.freeze

    def model!(params)
      ::Link.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page).to_h)
    end
  end

  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model Link

    callback :after_create, Callbacks::AfterCreate
    callback :after_save, Callbacks::AfterSave
    callback :before_destroy, Callbacks::BeforeDestroy
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

  class RemoveFromStory < Operation
    action :find

    def process(*)
      model.update_attributes(story_id: nil)
      Story::Builder.run(link_id: model.id)
    end
  end
end
