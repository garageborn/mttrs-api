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

  class Create < Form
    action :create
  end

  class Update < Form
    action :update
  end

  class Destroy < Operation
    action :find

    def process(*)
      model.destroy
      destroy_image
    end

    private

    def destroy_image
      return if model.image_source_url.blank?
      Cloudinary::Uploader.destroy(model.image_source_url, type: :fetch)
    end
  end

  class RemoveFromStory < Operation
    action :find

    def process(*)
      model.update_attributes(story_id: nil)
      StoryBuilderJob.perform_async(model.id)
    end
  end
end
