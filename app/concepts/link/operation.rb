require 'reform/form/validation/unique_validator'

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
    model Link
  end

  class Form < Operation
    contract Contract

    def process(params)
      validate(params[:link]) do
        contract.save
      end
    end
  end

  class Create < Form
    action :create
  end

  class Update < Create
    action :update
  end

  class Destroy < Operation
    action :find

    def process(*)
      model.destroy
      model.links.clear
    end
  end

  class RemoveFromStory < Operation
    action :find

    def process(*)
      model.update_attributes(story_id: nil)
      StoryBuilderJob.perform_later(model.id)
    end
  end
end
