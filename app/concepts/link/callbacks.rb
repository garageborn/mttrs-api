class Link
  module Callbacks
    class Base
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end
    end

    class AfterSave < Base
      def call(_options)
        refresh_story!
        perform_set_category!
        enqueue_link_full_fetch!
        enqueue_story_builder!
      end

      private

      def refresh_story!
        Link::RefreshStory.run(id: contract.model.id)
      end

      def perform_set_category!
        Link::SetCategory.run(id: contract.model.id)
      end

      def enqueue_link_full_fetch!
        return unless contract.model.needs_full_fetch?
        FullFetchLinkJob.perform_async(contract.model.id)
      end

      def enqueue_story_builder!
        StoryBuilderJob.perform_async(contract.model.id)
      end
    end

    class BeforeDestroy < Base
      def call(_options)
        destroy_image!
        destroy_tenant_associations!
      end

      private

      def destroy_image!
        return unless Rails.env.production?
        return if contract.model.image_source_url.blank?
        Cloudinary::Uploader.destroy(contract.model.image_source_url, type: :fetch)
      end

      def destroy_tenant_associations!
        Apartment::Tenant.each do
          model = contract.model.reload
          CategoryLink::Destroy.run(id: model.category_link.id) if model.category_link.present?
          StoryLink::Destroy.run(id: model.story_link.id) if model.story_link.present?
          BlockedStoryLink::DestroyAll.run(model.blocked_story_link_ids) if model.blocked_story_links.present?
          Access::DestroyAll.run(model.access_ids)
        end
      end
    end
  end
end
