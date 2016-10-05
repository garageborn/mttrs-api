class Category
  module Callbacks
    class Base
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end
    end

    class BeforeDestroy < Base
      def call(_options)
        destroy_icon!
      end

      private

      def destroy_icon!
        return if contract.model.icon_id.blank?
        Cloudinary::Uploader.destroy(contract.model.icon_id)
      end
    end
  end
end
