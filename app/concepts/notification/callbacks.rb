class Notification
  module Callbacks
    class AfterCreate
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end

      def call(_options)
        enqueue_deliver_notification!
      end

      private

      def enqueue_deliver_notification!
        NotificationDeliverJob.perform_async(contract.model.id)
      end
    end
  end
end
