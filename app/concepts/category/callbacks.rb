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
        destroy_image!
      end

      private

      def destroy_image!
        return if contract.model.image_id.blank?
        Cloudinary::Uploader.destroy(contract.model.image_id)
      end
    end
  end
end
