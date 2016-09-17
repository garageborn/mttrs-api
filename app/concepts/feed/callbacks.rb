class Feed
  module Callbacks
    class Base
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end
    end

    class AfterSave < Base
      def call(_options)
        enqueue_feed_fetcher!
      end

      private

      def enqueue_feed_fetcher!
        FeedFetcherJob.perform_async(contract.model.id)
      end
    end

    class BeforeDestroy < Base
      def call(_options)
        destroy_tenant_associations!
      end

      private

      def destroy_tenant_associations!
        Apartment::Tenant.each do
          model = contract.model.reload
          CategoryFeed::DestroyAll.run(model.category_feed_ids)
        end
      end
    end
  end
end
