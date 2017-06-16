class Link
  class UpdateStory < Operation
    def process(params)
      Apartment::Tenant.each do
        Link::UpdateStory::Tenant.run(id: params[:id])
      end
    end

    class Tenant < Operation
      action :find
      delegate :story, to: :model

      def process(_params)
        return if story.blank? || story.links.size != 1

        story.update_attributes(category: model.category, published_at: model.published_at)
      end
    end
  end
end
