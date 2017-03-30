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
        enqueue_link_set_category_job!
      end

      private

      def enqueue_link_set_category_job!
        links = contract.model.publisher.links.available_on_current_tenant.uncategorized
        links.find_each { |link|  LinkSetCategoryJob.perform_async(link.id) }
      end
    end
  end
end
