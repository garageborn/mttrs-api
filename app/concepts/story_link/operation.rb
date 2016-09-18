class StoryLink
  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model StoryLink
    contract Contract

    callback :after_destroy, ::StoryLink::Callbacks::AfterDestroy
  end

  class Destroy < Operation
    action :find

    def process(*)
      model.destroy
      callback!(:after_destroy)
    end
  end
end
