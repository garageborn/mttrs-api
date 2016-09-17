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
        enqueue_social_counter_fetcher!
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

      def enqueue_social_counter_fetcher!
        SocialCounterFetcherJob.perform_async(contract.model.id)
      end
    end

    class AfterSave < Base
      def call(options)
        refresh_story!
      end

      private

      def refresh_story!
        Story::Refresh.run(link_id: contract.model.id)
      end
    end

    class BeforeDestroy < Base
      def call(options)
        destroy_image!
        destroy_tenant_associations!
        refresh_story!
      end

      private

      def destroy_image!
        return if contract.model.image_source_url.blank?
        Cloudinary::Uploader.destroy(contract.model.image_source_url, type: :fetch)
      end

      def refresh_story!
        Story::Refresh.run(id: contract.model.story.id)
      end
    end
  end
end
