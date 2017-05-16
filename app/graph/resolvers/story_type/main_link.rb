module Resolvers
  module StoryType
    class MainLink < Base
      def resolve
        main_publisher_link || obj.main_link
      end

      private

      def publisher_ids
        args['publisher_ids']
      end

      def publisher_slug
        args['publisher_slug']
      end

      def main_publisher_link
        return if publisher_ids.blank? && publisher_slug.blank?
        obj.main_publisher_link(slug: publisher_slug, ids: publisher_ids)
      end

      memoize :publisher_slug
    end
  end
end
