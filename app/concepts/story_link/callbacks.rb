class StoryLink
  module Callbacks
    class AfterDestroy
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end

      def call(_options)
        refresh_story!
      end

      private

      def refresh_story!
        RefreshStoryJob.perform_async(contract.model.story_id)
      end
    end
  end
end
