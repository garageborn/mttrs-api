module Resolvers
  module LinkType
    class ImageSourceUrl < Base
      def resolve
        return obj.image_source_url if obj.image_source_url.present?
        story_images.first
      end

      private

      def story_images
        return [] if obj.story.blank?
        obj.story.links.popular.pluck(:image_source_url).compact.uniq
      end

      memoize :story_images
    end
  end
end
