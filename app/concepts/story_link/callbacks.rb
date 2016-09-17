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
        Story::Refresh.run(id: contract.model.story_id)
      end
    end
  end
end
