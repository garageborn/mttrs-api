class Link
  module Callbacks
    class Base
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end
    end

    class AfterCreate < Base
      def call(_options)
        perform_add_categories!
        enqueue_story_builder!
        enqueue_link_full_fetch!
      end

      private

      def perform_add_categories!
        Link::AddCategories.run(id: contract.model.id)
      end

      def enqueue_story_builder!
        StoryBuilderJob.perform_async(contract.model.id)
      end

      def enqueue_link_full_fetch!
        return unless contract.model.needs_full_fetch?
        FullFetchLinkJob.perform_async(contract.model.id)
      end
    end

    class AfterSave < Base
      def call(_options)
        refresh_story!
      end

      private

      def refresh_story!
        Link::RefreshStory.run(id: contract.model.id)
      end
    end

    class BeforeDestroy < Base
      def call(_options)
        destroy_image!
        destroy_tenant_associations!
      end

      private

      def destroy_image!
        return if contract.model.image_source_url.blank?
        Cloudinary::Uploader.destroy(contract.model.image_source_url, type: :fetch)
      end

      def destroy_tenant_associations!
        Apartment::Tenant.each do
          model = contract.model.reload
          CategoryLink::DestroyAll.run(model.category_link_ids)
          StoryLink::Destroy.run(id: model.story_link.id) if model.story_link.present?
        end
      end
    end
  end
end
