module Resolvers
  module LinkType
    class Image < Base
      def resolve
        OpenStruct.new(
          original: original_url,
          thumb: thumb_url
        )
      end

      private

      def original_url
        return obj.image_source_url if obj.image.blank?
        obj.image.url
      end

      def thumb_url
        return obj.image_source_url if obj.image.blank?
        style_name = dpr.present? ? "thumb_#{ dpr }x".to_sym : :thumb
        obj.image.url(style_name)
      end

      def dpr
        dpr = args['dpr'].to_f
        dpr > 1 ? 2 : nil
      end

      memoize :dpr
    end
  end
end
