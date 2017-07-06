module Resolvers
  module LinkImageType
    class Thumb < Base
      def resolve
        return obj.instance.image_source_url if obj.blank?
        obj.url(:thumb)
      end
    end
  end
end
