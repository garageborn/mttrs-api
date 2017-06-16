module Resolvers
  module StoryType
    class Publishers < Base
      def resolve
        # return obj.other_links.filter(filters) if main_publisher_link.blank?
        # obj.links.where.not(id: main_publisher_link).filter(filters)
        obj.publishers.filter(filters)
      end

      private

      # def publisher_ids
      #   args['publisher_ids']
      # end

      # def publisher_slug
      #   args['publisher_slug']
      # end

      # def main_publisher_link
      #   return if publisher_ids.blank? && publisher_slug.blank?
      #   obj.main_publisher_link(slug: publisher_slug, ids: publisher_ids)
      # end

      def filters
        args.slice('popular', 'limit')
      end

      memoize :filters
    end
  end
end
