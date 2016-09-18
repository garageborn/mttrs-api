class SocialCounter
  module Callbacks
    class AfterSave
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end

      def call(_options)
        update_total_social_on_link!
      end

      private

      def update_total_social_on_link!
        Link::UpdateTotalSocial.run(
          model: contract.model.link,
          total_social: contract.model.total
        )
      end
    end
  end
end
