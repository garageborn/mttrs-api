class CategoryMatcher
  module Callbacks
    class Base
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end
    end

    class AfterSave < Base
      def call(_options)
        perform_add_link_categories!
      end

      private

      def perform_add_link_categories!
        contract.model.publisher.links.uncategorized.find_each do |link|
          LinkCategorizerJob.perform_async(link.id)
        end
      end
    end
  end
end
