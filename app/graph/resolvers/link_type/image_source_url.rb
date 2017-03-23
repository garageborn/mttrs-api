module Resolvers
  module LinkType
    class ImageSourceUrl < Base
      def resolve
        return obj.image_source_url if obj.image_source_url.present?
        story_main_image_source_url
      end

      private

      def story_main_image_source_url
        return if obj.story.blank?
        obj.story.main_image_source_url
      end

      memoize :story_main_image_source_url
    end
  end
end
