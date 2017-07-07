module Resolvers
  module PublisherType
    class Icon < Base
      STYLES = %i[xsmall small medium]

      def resolve
        OpenStruct.new(
          xsmall: style_url(:xsmall),
          small: style_url(:small),
          medium: style_url(:medium)
        )
      end

      private

      def style_url(style)
        style_name = dpr.present? ? "#{ style }_#{ dpr }x".to_sym : style.to_sym
        obj.icon.url(style_name)
      end

      def dpr
        dpr = args['dpr'].to_f
        dpr > 1 ? 2 : nil
      end

      memoize :dpr
    end
  end
end
