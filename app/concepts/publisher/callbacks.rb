class Publisher
  module Callbacks
    class AfterCreate
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end

      def call(_options)
        BuzzsumoFetcherJob.perform_async(contract.model.id)
        TitleReplacementsJob.perform_async(contract.model.id)
      end
    end

    class AfterUpdate
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end

      def call(_options)
        TitleReplacementsJob.perform_async(contract.model.id)
      end
    end

    class BeforeDestroy
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end

      def call(_options)
        destroy_associations!
        destroy_tenant_associations!
      end

      private

      def destroy_associations!
        Link::DestroyAll.run(contract.model.link_ids)
      end

      def destroy_tenant_associations!
        Apartment::Tenant.each do
          model = contract.model.reload
          CategoryMatcher::DestroyAll.run(model.category_matcher_ids)
          TagMatcher::DestroyAll.run(model.tag_matcher_ids)
        end
      end
    end
  end
end
