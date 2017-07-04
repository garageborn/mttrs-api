module Resolvers
  module LinkType
    class ImageUrl < Base
      def resolve
        return obj.image_source_url if format.blank?
        obj.dynamic_image_url(format)
      end

      private

      def format
        args['format']
      end

      memoize :format
    end
  end
end
