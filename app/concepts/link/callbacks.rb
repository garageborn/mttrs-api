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
        perform_story_builder!
        enqueue_link_full_fetch!
        enqueue_social_counter_fetcher!
      end

      private

      def perform_add_categories!
        Link::AddCategories.run(id: contract.model.id)
      end

      def perform_story_builder!
        Story::Builder.run(link_id: contract.model.id)
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
  end
end
