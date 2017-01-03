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
        links = contract.model.publisher.links.available_on_current_tenant.uncategorized
        links.find_each { |link| LinkCategorizerJob.perform_async(link.id) }
      end
    end
  end
end
