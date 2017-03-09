class Link
  class RefreshStory < Operation
    def process(params)
      Apartment::Tenant.each do
        Link::RefreshStory::Tenant.run(id: params[:id])
      end
    end

    class Tenant < Operation
      action :find

      def process(_params)
        return if model.story.blank?
        RefreshStoryJob.perform_async(model.story.id)
      end
    end
  end
end
