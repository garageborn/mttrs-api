module Resolvers
  module StoryType
    class MainLink < Base
      def resolve
        return obj.main_link if publisher_slug.blank?
        obj.main_publisher_link(publisher_slug)
      end

      private

      def publisher_slug
        args['publisher_slug']
      end

      memoize :publisher_slug
    end
  end
end
