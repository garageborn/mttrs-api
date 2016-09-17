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
        p '---------------after destroy', contract.model
        Story::Refresh.run(link_id: contract.model.link_id)
      end
    end
  end
end
