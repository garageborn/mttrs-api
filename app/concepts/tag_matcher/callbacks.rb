class TagMatcher
  module Callbacks
    class Base
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end
    end

    class AfterSave < Base
      def call(_options)
        enqueue_set_tags_job!
      end

      private

      def enqueue_set_tags_job!
        publisher = contract.model.publisher
        category = contract.model.tag.category
        links = publisher.links.category_slug(category.slug).available_on_current_tenant
        links.pluck(:id).each { |id| LinkSetTagsJob.perform_async(id) }
      end
    end
  end
end
