module Resolvers
  module LinkImageType
    class Original < Base
      def resolve
        return obj.instance.image_source_url if obj.blank?
        obj.url
      end
    end
  end
end
